using System;
using System.Collections.Generic;
using UnityEngine;

public class Airplane
{
    public string TailNumber { get; private set; }
    public string Type { get; private set; }
    public SortedList<DateTime, Vector2> Locations { get; private set; }

    public Airplane(string tailNumber, string type)
    {
        TailNumber = tailNumber;
        Type = type;
        Locations = new SortedList<DateTime, Vector2>();
    }

    public void AddLocation(string timeStr, string latStr, string lonStr)
    {
        if (DateTime.TryParse(timeStr, out DateTime time) &&
            float.TryParse(latStr, out float lat) &&
            float.TryParse(lonStr, out float lon))
        {
            if (!Locations.ContainsKey(time))
            {
                Locations.Add(time, new Vector2(lat, lon));
            }
        }
        else
        {
            Debug.LogWarning("Failed to parse location data");
        }
    }
}
