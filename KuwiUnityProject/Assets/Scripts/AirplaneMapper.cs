using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AirplaneMapper : MonoBehaviour
{
    [Header("Prefabs & Parents")]
    [SerializeField] private GameObject airplanePrefab;
    [SerializeField] private GameObject markerPrefab;
    [SerializeField] private Transform airplanesParent;
    [SerializeField] private Transform markersParent;

    [Header("Playback")]
    [Tooltip("Compress real time by this factor. 12 => a 5 minute gap plays in 25 seconds.")]
    [SerializeField] private float timeCompression = 12f;
    [Tooltip("Place a marker every Nth point (1 = every point).")]
    [SerializeField] private int markerInterval = 10;
    [Tooltip("Keep at most this many active markers. 0 = unlimited.")]
    [SerializeField] private int markerMaxCount = 200;
    [Tooltip("Seconds before a marker is culled. 0 = never cull by time.")]
    [SerializeField] private float markerLifetimeSeconds = 300f;

    [Header("Globe")]
    [SerializeField] private float globeRadius = 1f;
    [SerializeField] private Vector3 globeCenter = Vector3.zero;
    [SerializeField] private bool altitudeIsFeet = true;

    [Header("Tail numbers to play")]
    [SerializeField] private List<string> tailNumbers = new List<string>();
    [Tooltip("If enabled, fetch the most popular airplanes from the API instead of using the list above.")]
    [SerializeField] private bool usePopularFromApi = false;
    [SerializeField] private int popularCount = 3;

    private readonly Dictionary<string, Airplane> activeAirplanes = new Dictionary<string, Airplane>();

    private void Start()
    {
        if (usePopularFromApi)
        {
            StartCoroutine(LoadPopularAndSpawn());
        }
        else
        {
            StartFlightsFromList(tailNumbers);
        }
    }

    private void StartFlightsFromList(IEnumerable<string> tails)
    {
        // If popular mode is enabled, ignore the inspector list to avoid double-loading.
        if (usePopularFromApi && ReferenceEquals(tails, tailNumbers))
        {
            return;
        }

        foreach (var tail in tails)
        {
            if (string.IsNullOrWhiteSpace(tail)) continue;
            StartCoroutine(LoadAndSpawn(tail.Trim()));
        }
    }

    private IEnumerator LoadPopularAndSpawn()
    {
        yield return CoordinateFetcher.FetchTopAirplanes(
            Mathf.Max(1, popularCount),
            list =>
            {
                StartFlightsFromList(list);
            },
            error => Debug.LogError(error));
    }

    private IEnumerator LoadAndSpawn(string tailNumber)
    {
        yield return CoordinateFetcher.FetchAirplane(
            tailNumber,
            response =>
            {
                var path = ListCoordinateMapper.MapToWorld(response, globeRadius, globeCenter, altitudeIsFeet);
                if (path.Count == 0)
                {
                    Debug.LogWarning($"No valid points for {tailNumber}.");
                    return;
                }

                var airplaneGO = Instantiate(airplanePrefab, airplanesParent == null ? transform : airplanesParent);
                if (!airplaneGO.activeSelf)
                {
                    airplaneGO.SetActive(true);
                }
                airplaneGO.name = $"Airplane_{tailNumber}";

                var airplane = airplaneGO.GetComponent<Airplane>();
                if (airplane == null)
                {
                    airplane = airplaneGO.AddComponent<Airplane>();
                }

                activeAirplanes[tailNumber] = airplane;
                airplane.Initialize(
                    tailNumber,
                    path,
                    markerPrefab,
                    markersParent == null ? transform : markersParent,
                    timeCompression,
                    Mathf.Max(1, markerInterval),
                    Mathf.Max(0, markerMaxCount),
                    Mathf.Max(0f, markerLifetimeSeconds));
            },
            error => Debug.LogError(error));
    }
}
