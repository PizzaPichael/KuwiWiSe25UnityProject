// 16.11.2025 AI-Tag
// This was created with the help of Assistant, a Unity Artificial Intelligence product.

using UnityEngine;

public class SpinObject : MonoBehaviour
{
    // Speed of rotation around the Y-axis
    public float rotationSpeed = 50f;

    void Update()
    {
        // Rotate the object around the Y-axis
        transform.Rotate(0, 0, rotationSpeed * Time.deltaTime);
    }
}