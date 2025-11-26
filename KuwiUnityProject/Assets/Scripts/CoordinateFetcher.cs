using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public static class CoordinateFetcher
{
    private const string BaseUrl = "https://flights.davidkirchner.de/api/airplanes/";

    [Serializable]
    public class AirplaneLocation
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
    public class AirplaneResponse
    {
        public string tail_number;
        public string type;
        public string type_description;
        public List<AirplaneLocation> locations;
    }

    public static IEnumerator FetchAirplane(string tailNumber, Action<AirplaneResponse> onSuccess, Action<string> onError = null)
    {
        if (string.IsNullOrWhiteSpace(tailNumber))
        {
            onError?.Invoke("Tail number is empty.");
            yield break;
        }

        var url = BaseUrl + Uri.EscapeDataString(tailNumber);
        using var request = UnityWebRequest.Get(url);
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            onError?.Invoke($"Failed to fetch {tailNumber}: {request.error}");
            yield break;
        }

        AirplaneResponse response;
        try
        {
            response = JsonUtility.FromJson<AirplaneResponse>(request.downloadHandler.text);
        }
        catch (Exception e)
        {
            onError?.Invoke($"Failed to parse response for {tailNumber}: {e.Message}");
            yield break;
        }

        if (response == null || response.locations == null || response.locations.Count == 0)
        {
            onError?.Invoke($"No locations returned for {tailNumber}.");
            yield break;
        }

        onSuccess?.Invoke(response);
    }
}
