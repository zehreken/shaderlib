Shader "ShaderLib/UnlitColor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Color ("Color", Color) = (0, 0, 0, 0)
    }
    
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }
        
        CGPROGRAM
        // It is weird to define lighting model for an unlit shader
        #pragma surface surf Lambert
        
        sampler2D _MainTex;
        half4 _Color;
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Emission = tex2D (_MainTex, IN.uv_MainTex).rgb * _Color;
        }
        ENDCG
    }
}