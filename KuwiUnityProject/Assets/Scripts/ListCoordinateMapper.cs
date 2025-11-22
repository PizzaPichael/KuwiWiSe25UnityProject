using System.Collections.Generic;
using UnityEngine;

public class ListCoordinateMapper : MonoBehaviour
{
    [SerializeField] private string planeURL;
    [SerializeField] private Transform sphere;
    [SerializeField] private float radius = 1.2f;
    [SerializeField] private Transform indicatorPrefab;
    [SerializeField] private Color indicatorColor = Color.red;  // default color

    private List<Transform> indicators = new List<Transform>();

    void Start()
    {
        StartCoroutine(CoordinateFetcher.GetAirplaneStatic(planeURL, (result) =>
        {
            if (result != null)
            {
                Debug.Log("Airplane loaded with locations: " + result.Locations.Count);
                List<Vector2> locationList = new List<Vector2>(result.Locations.Values);
                SetLocations(locationList);
            }
            else
            {
                Debug.LogWarning("Failed to load airplane data.");
            }
        }));
    }

    Vector3 LatLonToSphere(float lat, float lon, float r)
    {
        float latRad = lat * Mathf.Deg2Rad;
        float lonRad = lon * Mathf.Deg2Rad;
        float x = r * Mathf.Cos(latRad) * Mathf.Cos(lonRad);
        float y = r * Mathf.Sin(latRad);
        float z = r * Mathf.Cos(latRad) * Mathf.Sin(lonRad);
        return new Vector3(x, y, z);
    }

    public void SetLocations(List<Vector2> latLonList)
    {
        foreach (var ind in indicators)
        {
            if (ind != null) Destroy(ind.gameObject);
        }
        indicators.Clear();

        foreach (var latLon in latLonList)
        {
            Vector3 position = LatLonToSphere(latLon.x, latLon.y, radius);
            Transform newIndicator = Instantiate(indicatorPrefab, position, Quaternion.identity, sphere);

            // Apply the indicator color
            Renderer rend = newIndicator.GetComponent<Renderer>();
            if (rend != null)
            {
                rend.material.color = indicatorColor;
            }

            indicators.Add(newIndicator);
        }
    }
}
