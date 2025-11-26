using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AirplaneMapper : MonoBehaviour
{
    [Header("API")]
    [SerializeField] private string baseUrl = "https://flights.davidkirchner.de/api/airplanes";
    [SerializeField] private List<string> tailNumbers = new List<string>();

    [Header("Scene")]
    [SerializeField] private Transform sphere;
    [SerializeField] private float sphereRadius = 1.2f;
    [SerializeField] private GameObject airplanePrefab;
    [SerializeField] private GameObject pathMarkerPrefab;

    [Header("Playback")]
    [SerializeField] private float timeScale = 60f; // seconds in data / second in scene
    [SerializeField] private float minSegmentDuration = 0.5f;
    [SerializeField] private bool autoStartOnPlay = true;

    private readonly Dictionary<string, AirplaneInstance> _activePlanes = new Dictionary<string, AirplaneInstance>();

    private void Start()
    {
        if (autoStartOnPlay)
        {
            FetchAll();
        }
    }

    public void FetchAll()
    {
        foreach (var tail in tailNumbers)
        {
            if (!string.IsNullOrWhiteSpace(tail))
            {
                StartCoroutine(FetchAndSpawn(tail.Trim()));
            }
        }
    }

    public void SetTailNumbers(List<string> newTailNumbers, bool refresh = true)
    {
        tailNumbers = newTailNumbers;
        if (refresh)
        {
            ResetAll();
            FetchAll();
        }
    }

    private void ResetAll()
    {
        foreach (var plane in _activePlanes.Values)
        {
            CleanupInstance(plane);
        }

        _activePlanes.Clear();
    }

    private IEnumerator FetchAndSpawn(string tailNumber)
    {
        string url = BuildUrl(tailNumber);
        Airplane fetched = null;

        Debug.Log($"[AirplaneMapper] Fetching {tailNumber} from {url}");
        yield return StartCoroutine(CoordinateFetcher.GetAirplaneStatic(url, a => fetched = a));

        if (fetched == null)
        {
            Debug.LogWarning($"Failed to fetch airplane {tailNumber}");
            yield break;
        }

        SpawnPlane(fetched);
    }

    private void SpawnPlane(Airplane airplane)
    {
        if (airplanePrefab == null || sphere == null)
        {
            Debug.LogError("AirplaneMapper missing prefab or sphere reference");
            return;
        }

        if (_activePlanes.TryGetValue(airplane.TailNumber, out var existing))
        {
            CleanupInstance(existing);
        }

        var instance = new AirplaneInstance();
        instance.Root = Instantiate(airplanePrefab, sphere).transform;
        instance.Root.name = $"Airplane_{airplane.TailNumber}";

        var waypoints = BuildWaypoints(airplane);
        if (waypoints.Count == 0)
        {
            Debug.LogWarning($"Airplane {airplane.TailNumber} has no locations to map.");
            Destroy(instance.Root.gameObject);
            return;
        }

        Debug.Log($"[AirplaneMapper] {airplane.TailNumber} waypoints: {waypoints.Count} | first {waypoints[0].Time:o} | last {waypoints[waypoints.Count - 1].Time:o}");

        // Place at first waypoint immediately
        instance.Root.localPosition = waypoints[0].Position;

        // Drop marker for starting point only
        TrySpawnMarker(instance, waypoints, 0);

        _activePlanes[airplane.TailNumber] = instance;
        instance.AnimationCoroutine = StartCoroutine(AnimatePlane(instance, waypoints));
    }

    private IEnumerator AnimatePlane(AirplaneInstance instance, List<Waypoint> waypoints)
    {
        if (instance.Root == null || waypoints.Count < 2)
        {
            Debug.LogWarning("[AirplaneMapper] Not enough waypoints to animate");
            yield break;
        }

        while (true)
        {
            for (int i = 0; i < waypoints.Count - 1; i++)
            {
                yield return MoveBetween(instance.Root, waypoints[i], waypoints[i + 1]);
                TrySpawnMarker(instance, waypoints, i + 1);
            }

            // Loop back to start
            yield return MoveBetween(instance.Root, waypoints[waypoints.Count - 1], waypoints[0]);
            TrySpawnMarker(instance, waypoints, 0);
        }
    }

    private IEnumerator MoveBetween(Transform plane, Waypoint from, Waypoint to)
    {
        float duration = Mathf.Max((float)(to.Time - from.Time).TotalSeconds / Mathf.Max(timeScale, 0.01f), minSegmentDuration);
        float elapsed = 0f;

        Debug.Log($"[AirplaneMapper] Segment {from.Time:o} -> {to.Time:o} duration={duration:0.00}s (scale={timeScale}, min={minSegmentDuration})");

        Vector3 startDir = from.Position.normalized;
        Vector3 endDir = to.Position.normalized;
        Vector3 greatCircleNormal = Vector3.Cross(startDir, endDir);
        if (greatCircleNormal.sqrMagnitude < 1e-6f)
        {
            greatCircleNormal = Vector3.Cross(startDir, Vector3.up);
        }
        Vector3 lastForward = plane.forward;
        Vector3 prevPos = from.Position;

        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float t = Mathf.Clamp01(elapsed / duration);
            Vector3 slerpPos = Vector3.Slerp(startDir, endDir, t) * sphereRadius;
            plane.localPosition = slerpPos;

            // Orient so down faces the center and forward follows motion
            Vector3 up = slerpPos.normalized;
            Vector3 tangent = Vector3.Cross(greatCircleNormal, up);
            if (tangent.sqrMagnitude < 1e-6f)
            {
                tangent = lastForward;
            }

            lastForward = tangent.normalized;
            Quaternion targetRot = Quaternion.LookRotation(lastForward, up);
            plane.localRotation = Quaternion.Slerp(plane.localRotation, targetRot, 10f * Time.deltaTime);
            prevPos = slerpPos;
            yield return null;
        }

        plane.localPosition = to.Position;
        Vector3 finalUp = to.Position.normalized;
        Vector3 finalFwd = Vector3.Cross(greatCircleNormal, finalUp);
        if (finalFwd.sqrMagnitude < 1e-4f)
        {
            finalFwd = lastForward;
        }
        plane.localRotation = Quaternion.LookRotation(finalFwd.normalized, finalUp);
    }

    private List<Waypoint> BuildWaypoints(Airplane airplane)
    {
        var waypoints = new List<Waypoint>();
        foreach (var kvp in airplane.Locations)
        {
            Vector3 pos = LatLonToSphere(kvp.Value.x, kvp.Value.y, sphereRadius);
            waypoints.Add(new Waypoint { Time = kvp.Key, Position = pos });
        }

        return waypoints;
    }

    private Vector3 LatLonToSphere(float lat, float lon, float r)
    {
        float latRad = lat * Mathf.Deg2Rad;
        float lonRad = lon * Mathf.Deg2Rad;
        float x = r * Mathf.Cos(latRad) * Mathf.Cos(lonRad);
        float y = r * Mathf.Sin(latRad);
        float z = r * Mathf.Cos(latRad) * Mathf.Sin(lonRad);
        return new Vector3(x, y, z);
    }

    private string BuildUrl(string tail) => $"{baseUrl.TrimEnd('/')}/{tail}";

    private void CleanupInstance(AirplaneInstance instance)
    {
        if (instance.AnimationCoroutine != null)
        {
            StopCoroutine(instance.AnimationCoroutine);
        }

        if (instance.Root != null)
        {
            Destroy(instance.Root.gameObject);
        }

        foreach (var marker in instance.Markers)
        {
            if (marker != null)
            {
                Destroy(marker.gameObject);
            }
        }
    }

    private class AirplaneInstance
    {
        public Transform Root;
        public HashSet<int> SpawnedMarkerIndices = new HashSet<int>();
        public List<Transform> Markers = new List<Transform>();
        public Coroutine AnimationCoroutine;
    }

    private struct Waypoint
    {
        public DateTime Time;
        public Vector3 Position;
    }

    private void TrySpawnMarker(AirplaneInstance instance, List<Waypoint> waypoints, int index)
    {
        if (pathMarkerPrefab == null || instance == null || instance.SpawnedMarkerIndices.Contains(index))
        {
            return;
        }

        if (index < 0 || index >= waypoints.Count)
        {
            return;
        }

        Transform marker = Instantiate(pathMarkerPrefab, sphere).transform;
        marker.localPosition = waypoints[index].Position;
        instance.SpawnedMarkerIndices.Add(index);
        instance.Markers.Add(marker);
    }
}
