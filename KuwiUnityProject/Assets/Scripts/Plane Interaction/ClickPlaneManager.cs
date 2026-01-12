using TMPro;
using UnityEngine.UI;
using UnityEngine;
using UnityEngine.InputSystem;

public class ClickPlaneManager : MonoBehaviour
{
    private GameObject planeDetailsUI;
    private Camera mainCamera;
    [SerializeField] private Button closeButton;

    private TextMeshProUGUI headerAndTailNumber;
    private TextMeshProUGUI flugzeugtypText;
    private TextMeshProUGUI heightText;
    private TextMeshProUGUI speedText;
    private TextMeshProUGUI headingText;
    private TextMeshProUGUI latitudeText;
    private TextMeshProUGUI longitudeText;


    private Transform selectedAirplaneTransform;
    private Airplane selectedAirplane;
    private Outline selectedOutline;
    private Outline previousOutline;

    private void Awake()
    {

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

            if (closeButton != null)
            {
                closeButton.onClick.AddListener(OnPlaneDetailsCloseButtonClick);
            }
        }
    }

    private void CacheTextComponents()
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

    private TextMeshProUGUI FindTextComponent(Transform parent, string childName)
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
                if (hit.transform.CompareTag("airplane"))
                {
                    SelectAirplane(hit.transform);
                }
            }
        }

        if (planeDetailsUI != null && planeDetailsUI.activeInHierarchy && selectedAirplane != null)
        {
            UpdateUI();
        }
    }

    private void SelectAirplane(Transform hitTransform)
    {
        if (planeDetailsUI == null) return;

        if (selectedAirplaneTransform != null && selectedAirplaneTransform != hitTransform)
        {
            previousOutline = selectedOutline;
            SetOutline(previousOutline, false);
        }

        selectedAirplaneTransform = hitTransform;
        selectedAirplane = selectedAirplaneTransform.GetComponent<Airplane>();
        selectedOutline = selectedAirplaneTransform.GetComponent<Outline>();

        SetOutline(selectedOutline, true);

        if (!planeDetailsUI.activeInHierarchy)
        {
            planeDetailsUI.SetActive(true);
        }

        UpdateUI();
    }

    public void OnPlaneDetailsCloseButtonClick()
    {
        SetOutline(selectedOutline, false);
    }

    private void SetOutline(Outline outline, bool boolVal)
    {
        if (outline != null)
        {
            outline.enabled = boolVal;
        }
    }



    private void UpdateUI()
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
            if (selectedAirplane.CurrentAltitude != -1)
            {
                heightText.text = $"Height: {selectedAirplane.CurrentAltitude:F0} ft";
            }
            else
            {
                heightText.text = $"Height: On Ground";
            }

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
