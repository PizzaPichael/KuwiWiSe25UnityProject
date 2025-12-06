using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Networking;

public static class CoordinateFetcher
{
    private const string BaseUrl = "https://flights.davidkirchner.de/api/airplanes/";
    private const string PopularUrl = "https://flights.davidkirchner.de/api/airplanes/location-count/";

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

    [Serializable]
    public class PopularAirplane
    {
        public string tail_number;
        public string type;
        public int location_count;
    }

    [Serializable]
    private class PopularWrapper
    {
        public int count;
        public string next;
        public string previous;
        public List<PopularAirplane> results;
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

    public static IEnumerator FetchTopAirplanes(int take, Action<List<string>> onSuccess, Action<string> onError = null)
    {
        var url = $"{PopularUrl}?limit={Mathf.Max(1, take)}";
        using var request = UnityWebRequest.Get(url);
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            onError?.Invoke($"Failed to fetch popular airplanes: {request.error}");
            yield break;
        }

        PopularWrapper wrapped;
        try
        {
            wrapped = JsonUtility.FromJson<PopularWrapper>(request.downloadHandler.text);
        }
        catch (Exception e)
        {
            onError?.Invoke($"Failed to parse popular airplanes: {e.Message}");
            yield break;
        }

        if (wrapped?.results == null || wrapped.results.Count == 0)
        {
            onError?.Invoke("No popular airplanes returned.");
            yield break;
        }

        var result = wrapped.results
            .Where(p => !string.IsNullOrWhiteSpace(p.tail_number))
            .Take(Mathf.Max(1, take))
            .Select(p => p.tail_number.Trim())
            .ToList();

        onSuccess?.Invoke(result);
    }
}
