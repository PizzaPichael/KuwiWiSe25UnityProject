using System;
using System.Collections.Generic;
using System.Globalization;
using UnityEngine;

public static class ListCoordinateMapper
{
    public struct MappedLocation
    {
        public DateTime Timestamp;
        public Vector3 Position;
        public float Track;
        public float GroundSpeed;
        public float Altitude;
    }

    private const float EarthRadiusMeters = 6_371_000f;

    public static List<MappedLocation> MapToWorld(
        CoordinateFetcher.AirplaneResponse response,
        float globeRadius = 1f,
        Vector3 globeCenter = default,
        bool altitudeIsFeet = true)
    {
        var mapped = new List<MappedLocation>();
        if (response?.locations == null) return mapped;

        foreach (var loc in response.locations)
        {
            if (!double.TryParse(loc.latitude, NumberStyles.Float, CultureInfo.InvariantCulture, out var latDeg)) continue;
            if (!double.TryParse(loc.longitude, NumberStyles.Float, CultureInfo.InvariantCulture, out var lonDeg)) continue;
            if (!DateTime.TryParse(loc.time, CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal, out var timestamp)) continue;

            float altitudeMeters = altitudeIsFeet ? loc.altitude * 0.3048f : loc.altitude;
            float radialOffset = (altitudeMeters / EarthRadiusMeters) * globeRadius;

            float latRad = Mathf.Deg2Rad * (float)latDeg;
            float lonRad = Mathf.Deg2Rad * (float)lonDeg;

            float cosLat = Mathf.Cos(latRad);
            float sinLat = Mathf.Sin(latRad);
            float cosLon = Mathf.Cos(lonRad);
            float sinLon = Mathf.Sin(lonRad);

            var direction = new Vector3(
                cosLat * cosLon,
                sinLat,
                cosLat * sinLon
            );

            var worldPos = globeCenter + direction * (globeRadius + radialOffset);

            mapped.Add(new MappedLocation
            {
                Timestamp = timestamp,
                Position = worldPos,
                Track = loc.track,
                GroundSpeed = loc.ground_speed,
                Altitude = loc.altitude
            });
        }

        mapped.Sort((a, b) => a.Timestamp.CompareTo(b.Timestamp));
        return mapped;
    }
}
