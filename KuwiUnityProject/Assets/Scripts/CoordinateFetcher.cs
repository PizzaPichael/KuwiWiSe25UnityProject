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
    public float ground_speed;
    public float track;
    public float altitude;
}

[Serializable]
public class AirplaneData
{
    public string tail_number;
    public string type;
    public string type_description;
    public List<LocationData> locations;
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
