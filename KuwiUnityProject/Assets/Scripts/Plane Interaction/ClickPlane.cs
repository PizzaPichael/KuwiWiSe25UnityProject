using TMPro;
using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(Airplane))]
public class ClickPlane : MonoBehaviour
{
    private static GameObject planeDetailsUI;
    private static Camera mainCamera;
    private static Airplane selectedAirplane;

    private static TextMeshProUGUI headerAndTailNumber;
    private static TextMeshProUGUI flugzeugtypText;
    private static TextMeshProUGUI heightText;
    private static TextMeshProUGUI speedText;
    private static TextMeshProUGUI headingText;
    private static TextMeshProUGUI latitudeText;
    private static TextMeshProUGUI longitudeText;

    private Airplane airplane;

    private void Awake()
    {
        airplane = GetComponent<Airplane>();

        if (mainCamera == null)
        {
            mainCamera = Camera.main;
        }

        if (planeDetailsUI == null)
        {
            planeDetailsUI = GameObject.Find("Player/UiCanvas/PlaneDetailsUI");
            if (planeDetailsUI == null)
            {
                Debug.LogError("PlaneDetailsUI object not found in the scene!");
                return;
            }

            CacheTextComponents();
        }
    }

    private static void CacheTextComponents()
    {
        Transform flightComputerImage = planeDetailsUI.transform.Find("FlightComputerImage");
        if (flightComputerImage == null)
        {
            Debug.LogError("FlightComputerImage not found!");
            return;
        }

        headerAndTailNumber = FindTextComponent(flightComputerImage, "HeaderText");

        Transform infoSection = flightComputerImage.transform.Find("InformationSection");
        if (infoSection == null)
        {
            Debug.LogError("InformationSection not found!");
            return;
        }

        flugzeugtypText = FindTextComponent(infoSection, "FlugzeugtypText");
        heightText = FindTextComponent(infoSection, "HeightText");
        speedText = FindTextComponent(infoSection, "SpeedText");
        headingText = FindTextComponent(infoSection, "HeadingText");
        latitudeText = FindTextComponent(infoSection, "LatitudeText");
        longitudeText = FindTextComponent(infoSection, "LongtitudeText");
    }

    private static TextMeshProUGUI FindTextComponent(Transform parent, string childName)
    {
        Transform child = parent.Find(childName);
        if (child == null)
        {
            Debug.LogWarning($"{childName} not found!");
            return null;
        }
        return child.GetComponent<TextMeshProUGUI>();
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
                    SelectAirplane();
                }
            }
        }

        if (planeDetailsUI != null && planeDetailsUI.activeInHierarchy && selectedAirplane != null)
        {
            UpdateUI();
        }
    }

    private void SelectAirplane()
    {
        if (planeDetailsUI == null) return;

        selectedAirplane = airplane;

        if (!planeDetailsUI.activeInHierarchy)
        {
            planeDetailsUI.SetActive(true);
        }

        UpdateUI();
    }

    private static void UpdateUI()
    {
        if (selectedAirplane == null) return;

        if (headerAndTailNumber != null)
        {
            headerAndTailNumber.text = $"Airplane: {selectedAirplane.TailNumber}";
        }

        if (flugzeugtypText != null)
        {
            string typeDisplay = !string.IsNullOrEmpty(selectedAirplane.Type)
                ? selectedAirplane.Type
                : "Unknown";
            flugzeugtypText.text = $"Type: {typeDisplay}";
        }

        if (heightText != null)
        {
            heightText.text = $"Height: {selectedAirplane.CurrentAltitude:F0} ft";
        }

        if (speedText != null)
        {
            speedText.text = $"Speed: {selectedAirplane.CurrentSpeed:F0} kts";
        }

        if (headingText != null)
        {
            headingText.text = $"Heading: {selectedAirplane.CurrentHeading:F0}°";
        }

        if (latitudeText != null)
        {
            latitudeText.text = $"Lat.: {selectedAirplane.CurrentLatitude:F4}°";
        }

        if (longitudeText != null)
        {
            longitudeText.text = $"Long.: {selectedAirplane.CurrentLongitude:F4}°";
        }
    }
}
