Shader "ShaderLib/DiffuseWhite"
{
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }
        
        CGPROGRAM
        // Uses the Lambertian lighting model
        #pragma surface surf Lambert
        
        struct Input
        {
            float4 color;
        };
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = half4(1, 1, 1, 1).rgb;
        }
        ENDCG
    }
}
