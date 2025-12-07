using UnityEngine;
using UnityEngine.InputSystem;

public class ClickToInstantiate : MonoBehaviour
{
    [SerializeField] private GameObject prefabToInstantiate;
    [SerializeField] private Vector3 spawnPosition;

    private Camera mainCamera;

    private void Awake()
    {
        mainCamera = Camera.main;
    }

    private void Update()
    {
        if (Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame)
        {
            Ray ray = mainCamera.ScreenPointToRay(Mouse.current.position.ReadValue());
            if (Physics.Raycast(ray, out RaycastHit hit))
            {
                if (hit.transform == transform)
                {
                    if (prefabToInstantiate != null)
                    {
                        Instantiate(prefabToInstantiate, spawnPosition, Quaternion.identity);
                    }
                }
            }
        }
    }
}
