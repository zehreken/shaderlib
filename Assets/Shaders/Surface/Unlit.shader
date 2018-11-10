Shader "ShaderLib/Unlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
    }
    
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _MainTex;
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Emission = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
}