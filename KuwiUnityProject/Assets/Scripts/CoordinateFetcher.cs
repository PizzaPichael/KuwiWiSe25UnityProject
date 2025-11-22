using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Networking;

[Serializable]
public class LocationData
{
    public string time;
    public string airplane;
    public string latitude;
    public string longitude;
}

[Serializable]
public class AirplaneData
{
    public string tail_number;
    public string type;
    public List<LocationData> locations;
}

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
            Locations.Add(time, new Vector2(lat, lon));
        }
        else
        {
            Debug.LogWarning("Failed to parse location data");
        }
    }
}

public static class CoordinateFetcher
{
    public static IEnumerator GetAirplaneStatic(string url, Action<Airplane> callback)
    {
        UnityWebRequest www = UnityWebRequest.Get(url);
        yield return www.SendWebRequest();

        if (www.result != UnityWebRequest.Result.Success)
        {
            Debug.LogError(www.error);
            callback(null);
        }
        else
        {
            string json = www.downloadHandler.text;
            AirplaneData airplaneData = JsonUtility.FromJson<AirplaneData>(json);

            Airplane airplane = new Airplane(airplaneData.tail_number, airplaneData.type);

            foreach (var loc in airplaneData.locations)
            {
                airplane.AddLocation(loc.time, loc.latitude, loc.longitude);
            }

            callback(airplane);
        }
    }
}
