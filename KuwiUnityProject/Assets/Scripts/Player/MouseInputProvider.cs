using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class MouseInputProvider : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created

    public Vector2 WorldPosition { get; private set; }
    public event Action Clicked;

    private void OnLook(InputValue value)
    {
        var screenPos2D = value.Get<Vector2>();
        var screenPos = new Vector3(screenPos2D.x, screenPos2D.y, Camera.main.nearClipPlane);
        WorldPosition = Camera.main.ScreenToWorldPoint(screenPos);
    }

    private void OnSelect(InputValue _)
    {
        Clicked?.Invoke();
    }
}
