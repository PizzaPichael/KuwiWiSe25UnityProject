using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Airplane : MonoBehaviour
{
    [Tooltip("Optional: override up vector for the globe if it is not (0,1,0) locally.")]
    [SerializeField] private Vector3 customUp = Vector3.zero;

    private Coroutine flightRoutine;
    public string TailNumber { get; private set; }

    public void Initialize(
        string tailNumber,
        List<ListCoordinateMapper.MappedLocation> path,
        GameObject markerPrefab,
        Transform markerParent,
        float timeCompression)
    {
        TailNumber = tailNumber;
        if (flightRoutine != null)
        {
            StopCoroutine(flightRoutine);
        }

        flightRoutine = StartCoroutine(PlayFlight(path, markerPrefab, markerParent, timeCompression));
    }

    private IEnumerator PlayFlight(
        List<ListCoordinateMapper.MappedLocation> path,
        GameObject markerPrefab,
        Transform markerParent,
        float timeCompression)
    {
        if (path == null || path.Count == 0)
        {
            yield break;
        }

        // Drop markers for every sampled position.
        if (markerPrefab != null)
        {
            foreach (var point in path)
            {
                Instantiate(markerPrefab, point.Position, Quaternion.identity, markerParent);
            }
        }

        // Place at start.
        transform.position = path[0].Position;
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

                elapsed += Time.deltaTime;
                yield return null;
            }

            transform.position = next.Position;
            transform.rotation = targetRot;
        }
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
