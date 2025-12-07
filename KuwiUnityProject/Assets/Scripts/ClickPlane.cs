using UnityEngine;
using ISys = UnityEngine.InputSystem;
using ET = UnityEngine.InputSystem.EnhancedTouch;
using UnityEngine.Events;
using System;

public class ClickPlane : MonoBehaviour
{
    [SerializeField]
    private GameObject speechBubblePrefab;
    private GameObject instantiatedSpeechBubble;
    private CapsuleCollider _collider;
    private MouseInputProvider _mouse;

    public Vector3 bubbleOffsetFromPlane;

    private void Awake()
    {
        _collider = GetComponent<CapsuleCollider>();
        _mouse = FindAnyObjectByType<MouseInputProvider>();
        _mouse.Clicked += MouseOnClicked;
    }

    private void MouseOnClicked()
    {
        if (_collider.bounds.Contains(_mouse.WorldPosition))
        {
            Debug.Log("Bounds: " + _collider.bounds);
            Debug.Log("Mouse World Pos: " + _mouse.WorldPosition);
            if (instantiatedSpeechBubble != null)
            {
                Destroy(instantiatedSpeechBubble);
            }
            else
            {
                instantiatedSpeechBubble = Instantiate(speechBubblePrefab, this.transform.position + bubbleOffsetFromPlane, Quaternion.identity);
                //instantiatedSpeechBubble.SetActive(true);   
            }
        }
    }
}
