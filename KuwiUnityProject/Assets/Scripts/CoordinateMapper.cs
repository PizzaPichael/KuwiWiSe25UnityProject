using System;
using UnityEngine;

public class CoordinateMapper : MonoBehaviour
{
    [SerializeField] private float latitude;
    [SerializeField] private float longitude;
    [SerializeField] private Transform sphere;
    [SerializeField] private float radius = 1.2f;
    [SerializeField] private Transform indicator;
    void Start()
    {
        
    }
    
    Vector3 LatLonToSphere(float lat, float lon, float r)
    {
        // Convert degrees to radians
        float latRad = lat * Mathf.Deg2Rad;
        float lonRad = lon * Mathf.Deg2Rad;

        float x = r * Mathf.Cos(latRad) * Mathf.Cos(lonRad);
        float y = r * Mathf.Sin(latRad);
        float z = r * Mathf.Cos(latRad) * Mathf.Sin(lonRad);

        return new Vector3(x, y, z);
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 positionOnSphere = LatLonToSphere(latitude, longitude, radius);
        
        indicator.position = positionOnSphere;
    }
}
