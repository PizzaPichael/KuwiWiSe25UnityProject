// 22.11.2025 AI-Tag
// This was created with the help of Assistant, a Unity Artificial Intelligence product.

using UnityEngine;
using Vuforia;

public class ShowHideUI : MonoBehaviour
{
    public Canvas uiCanvas; // Referenz zu Ihrem UI-Canvas

    private void Start()
    {
        if (uiCanvas != null)
        {
            uiCanvas.enabled = false; // Canvas standardmäßig deaktivieren
        }
    }

    public void OnTrackingFound()
    {
        if (uiCanvas != null)
        {
            uiCanvas.enabled = true; // Canvas aktivieren, wenn das ImageTarget erkannt wird
        }
    }

    public void OnTrackingLost()
    {
        if (uiCanvas != null)
        {
            uiCanvas.enabled = false; // Canvas deaktivieren, wenn das ImageTarget nicht mehr erkannt wird
        }
    }
}