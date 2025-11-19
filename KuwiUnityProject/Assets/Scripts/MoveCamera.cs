// 16.11.2025 AI-Tag
// This was created with the help of Assistant, a Unity Artificial Intelligence product.

// 16.11.2025 AI-Tag
// This was created with the help of Assistant, a Unity Artificial Intelligence product.

using System;
using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(CharacterController))]
public class CameraMovement : MonoBehaviour
{
    public Camera playerCamera;
    public float moveSpeed = 5f;
    public float fastMoveSpeed = 10f;
    public float lookSpeed = 2f;
    public float lookXLimit = 45f;

    private Vector3 moveDirection = Vector3.zero;
    private float rotationX = 0;
    public bool canMove = true;

    private CharacterController characterController;

    void Start()
    {
        characterController = GetComponent<CharacterController>();
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void Update()
    {
        #region Handles Movement
        Vector3 forward = transform.TransformDirection(Vector3.forward);
        Vector3 right = transform.TransformDirection(Vector3.right);
        Vector3 up = transform.TransformDirection(Vector3.up);

        bool isFast = Keyboard.current.leftShiftKey.isPressed;
        float curSpeedX = canMove ? (isFast ? fastMoveSpeed : moveSpeed) * (Keyboard.current.wKey.isPressed ? 1 : Keyboard.current.sKey.isPressed ? -1 : 0) : 0;
        float curSpeedY = canMove ? (isFast ? fastMoveSpeed : moveSpeed) * (Keyboard.current.dKey.isPressed ? 1 : Keyboard.current.aKey.isPressed ? -1 : 0) : 0;
        float curSpeedZ = canMove ? (isFast ? fastMoveSpeed : moveSpeed) * (Keyboard.current.spaceKey.isPressed ? 1 : Keyboard.current.leftCtrlKey.isPressed ? -1 : 0) : 0;
        moveDirection = (forward * curSpeedX) + (right * curSpeedY) + (up * curSpeedZ);
        #endregion

        #region Handles rotation
        characterController.Move(moveDirection * Time.deltaTime);

        if (canMove)
        {
            rotationX += -Mouse.current.delta.y.ReadValue() * lookSpeed;
            rotationX = Mathf.Clamp(rotationX, -lookXLimit, lookXLimit);
            playerCamera.transform.localRotation = Quaternion.Euler(rotationX, 0, 0);
            transform.rotation *= Quaternion.Euler(0, Mouse.current.delta.x.ReadValue() * lookSpeed, 0);
        }
        #endregion
    }
}