// 13.12.2025 AI-Tag
// This was created with the help of Assistant, a Unity Artificial Intelligence product.

using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    public float moveSpeed = 0.5f;
    public float lookSpeed = 60f;
    public float lookXLimit = 75f;

    private CharacterController controller;
    private float movementX;
    private float movementZ;
    private float movementY;

    private float rotationX = 0f;
    private float rotationY = 0f;

    private Transform cameraTransform;

    private void Start()
    {
        controller = GetComponent<CharacterController>();

        // Get the camera's transform
        cameraTransform = Camera.main.transform;
    }

    public void OnMove(InputValue movementValue)
    {
        Vector2 movementVector = movementValue.Get<Vector2>();
        movementX = movementVector.x;
        movementZ = movementVector.y;
    }

    public void OnUp(InputValue movementValue)
    {
        float value = movementValue.Get<float>();
        movementY = value > 0f ? 1f : 0f;
    }

    public void OnDown(InputValue movementValue)
    {
        float value = movementValue.Get<float>();
        movementY = value > 0f ? -1f : 0f;
    }

    public void OnLook(InputValue lookValue)
    {
        if (Mouse.current.rightButton.isPressed)
        {
            Vector2 lookVector = lookValue.Get<Vector2>();
            rotationX -= lookVector.y * lookSpeed * Time.deltaTime;
            rotationY += lookVector.x * lookSpeed * Time.deltaTime;

            // Clamp the vertical rotation to prevent flipping
            rotationX = Mathf.Clamp(rotationX, -lookXLimit, lookXLimit);
        }
    }

    private void Update()
    {
        if (Mouse.current.rightButton.isPressed)
        {
            Cursor.lockState = CursorLockMode.Locked;
        }
        else if (Cursor.lockState != CursorLockMode.Confined)
        {
            Cursor.lockState = CursorLockMode.Confined;
        }
        // Calculate movement direction relative to the camera's orientation
        Vector3 forward = cameraTransform.forward;
        Vector3 right = cameraTransform.right;

        // Normalize the vectors
        forward.Normalize();
        right.Normalize();

        // Combine movement directions
        Vector3 movement = (forward * movementZ + right * movementX + Vector3.up * movementY) * moveSpeed * Time.deltaTime;

        controller.Move(movement);

        // Rotate the player horizontally
        transform.localRotation = Quaternion.Euler(0, rotationY, 0);

        // Rotate the camera vertically
        cameraTransform.localRotation = Quaternion.Euler(rotationX, 0, 0);
    }
}