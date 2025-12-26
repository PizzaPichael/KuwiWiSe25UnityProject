using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Airplane : MonoBehaviour
{
    [Tooltip("Optional: override up vector for the globe if it is not (0,1,0) locally.")]
    [SerializeField] private Vector3 customUp = Vector3.zero;

    private Coroutine flightRoutine;
    public string TailNumber { get; private set; }
    public string Type { get; private set; }
    public string TypeDescription { get; private set; }
    public float CurrentAltitude { get; private set; }
    public float CurrentSpeed { get; private set; }
    public float CurrentHeading { get; private set; }
    public float CurrentLatitude { get; private set; }
    public float CurrentLongitude { get; private set; }

    private readonly List<GameObject> activeMarkers = new List<GameObject>();
    private int markerInterval = 1;
    private int markerMaxCount = 0;
    private float markerLifetimeSeconds = 0f;

    public void Initialize(
        string tailNumber,
        string type,
        string typeDescription,
        List<ListCoordinateMapper.MappedLocation> path,
        GameObject markerPack,
        Transform markerParent,
        float timeCompression,
        int markerInterval,
        int markerMaxCount,
        float markerLifetimeSeconds)
    {
        TailNumber = tailNumber;
        Type = type;
        TypeDescription = typeDescription;
        if (flightRoutine != null)
        {
            StopCoroutine(flightRoutine);
        }

        CleanupMarkers();
        this.markerInterval = Mathf.Max(1, markerInterval);
        this.markerMaxCount = markerMaxCount;
        this.markerLifetimeSeconds = markerLifetimeSeconds;

        flightRoutine = StartCoroutine(PlayFlight(path, markerPack, markerParent, timeCompression));
    }

    private IEnumerator PlayFlight(
        List<ListCoordinateMapper.MappedLocation> path,
        GameObject markerPack,
        Transform markerParent,
        float timeCompression)
    {
        if (path == null || path.Count == 0)
        {
            yield break;
        }

        // Place at start.
        transform.position = path[0].Position;
        // Spawn initial marker at start (index 0).
        SpawnMarkerIfNeeded(markerPack, markerParent, 0, path.Count, path[0].Position);
        if (path.Count == 1)
        {
            SetRotation(Vector3.forward, path[0].Position);
            yield break;
        }

        float compression = Mathf.Max(0.01f, timeCompression);
        Vector3 initialDir = (path[1].Position - path[0].Position).normalized;
        SetRotation(initialDir, path[0].Position);

        for (int i = 0; i < path.Count - 1; i++)
        {
            var current = path[i];
            var next = path[i + 1];
            float realSeconds = Mathf.Max(0.01f, (float)(next.Timestamp - current.Timestamp).TotalSeconds);
            float segmentDuration = realSeconds / compression;

            float elapsed = 0f;
            var startRot = transform.rotation;
            Vector3 segmentDir = (next.Position - current.Position).normalized;
            var targetRot = ComputeRotation(segmentDir, next.Position);

            while (elapsed < segmentDuration)
            {
                float t = Mathf.Clamp01(elapsed / segmentDuration);
                Vector3 newPos = Vector3.Lerp(current.Position, next.Position, t);
                transform.position = newPos;

                transform.rotation = Quaternion.Slerp(startRot, targetRot, t);

                // Update current flight data
                CurrentAltitude = Mathf.Lerp(current.Altitude, next.Altitude, t);
                CurrentSpeed = Mathf.Lerp(current.GroundSpeed, next.GroundSpeed, t);
                CurrentHeading = Mathf.Lerp(current.Track, next.Track, t);
                CurrentLatitude = Mathf.Lerp(current.Latitude, next.Latitude, t);
                CurrentLongitude = Mathf.Lerp(current.Longitude, next.Longitude, t);

                elapsed += Time.deltaTime;
                yield return null;
            }

            transform.position = next.Position;
            transform.rotation = targetRot;

            // Set final values for this segment
            CurrentAltitude = next.Altitude;
            CurrentSpeed = next.GroundSpeed;
            CurrentHeading = next.Track;
            CurrentLatitude = next.Latitude;
            CurrentLongitude = next.Longitude;

            // Drop/activate marker for the point we just reached.
            SpawnMarkerIfNeeded(markerPack, markerParent, i + 1, path.Count, next.Position);
        }
    }

    private void SpawnMarkerIfNeeded(GameObject markerPack, Transform markerParent, int pathIndex, int pathCount, Vector3 position)
    {
        if (markerPack == null) return;

        bool shouldSpawn = pathIndex % markerInterval == 0 || pathIndex == pathCount - 1;
        if (!shouldSpawn) return;

        var randomIndex = Random.Range(0, markerPack.transform.childCount);
        var chosenMarker = markerPack.transform.GetChild(randomIndex).gameObject;

        var marker = Instantiate(chosenMarker, position, Quaternion.identity, markerParent);
        marker.SetActive(true);

        activeMarkers.Add(marker);

        if (markerMaxCount > 0)
        {
            while (activeMarkers.Count > markerMaxCount)
            {
                DestroyOldestMarker();
            }
        }

        if (markerLifetimeSeconds > 0f)
        {
            StartCoroutine(CullAfter(marker, markerLifetimeSeconds));
        }
    }

    private IEnumerator CullAfter(GameObject marker, float delay)
    {
        yield return new WaitForSeconds(delay);
        if (marker != null)
        {
            activeMarkers.Remove(marker);
            Destroy(marker);
        }
    }

    private void DestroyOldestMarker()
    {
        if (activeMarkers.Count == 0) return;
        var oldest = activeMarkers[0];
        activeMarkers.RemoveAt(0);
        if (oldest != null)
        {
            Destroy(oldest);
        }
    }

    private void CleanupMarkers()
    {
        foreach (var marker in activeMarkers)
        {
            if (marker != null)
            {
                Destroy(marker);
            }
        }
        activeMarkers.Clear();
    }

    private void SetRotation(Vector3 forward, Vector3 position)
    {
        transform.rotation = ComputeRotation(forward, position);
    }

    private Quaternion ComputeRotation(Vector3 forward, Vector3 position)
    {
        Vector3 up = customUp != Vector3.zero ? customUp.normalized : position.normalized;
        return Quaternion.LookRotation(forward, up);
    }
}
