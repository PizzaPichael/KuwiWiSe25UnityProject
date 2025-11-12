// 12.11.2025 AI-Tag
// This was created with the help of Assistant, a Unity Artificial Intelligence product.

Shader "Custom/InvertNormals"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Background" }
        Pass
        {
            Cull Front
            ZWrite Off
            Fog { Mode Off }
            SetTexture [_MainTex] { combine texture }
        }
    }
}