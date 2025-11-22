// 16.11.2025 AI-Tag
// This was created with the help of Assistant, a Unity Artificial Intelligence product.

using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class SpinObject : MonoBehaviour
{
    // Speed of rotation around the Y-axis
    public int rotationSpeed = 50;
    public Slider speedSlider;
    public TextMeshProUGUI valueText;

    private void Start()
    {
        if (speedSlider != null)
        {
            speedSlider.onValueChanged.AddListener(OnSliderValueChanged);
        }

    }

    void Update()
    {
        // Rotate the object around the Y-axis
        transform.Rotate(0, 0, rotationSpeed * Time.deltaTime);

        if (valueText != null)
        {
            valueText.text = rotationSpeed.ToString();
        }
    }


    private void OnSliderValueChanged(float value)
    {
        rotationSpeed = (int)value;
    }

}