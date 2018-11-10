// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "ShaderLib/Snow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _MainColor ("Main color", Color) = (1, 1, 1, 1)
        _Bump ("Bump", 2D) = "bump" { }
        _SnowLevel ("Snow level", Range(-1, 1)) = 1
        _SnowColor ("Snow color", Color) = (1, 1, 1, 1)
        _SnowDirection ("Snow direction", Vector) = (0, 1, 0)
        _SnowDepth ("Snow depth", Range(0, 0.1)) = 0
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Lambert vertex;vert
        
        sampler2D _MainTex;
        float4 _MainColor;
        sampler2D _Bump;
        float _SnowLevel;
        float4 _SnowColor;
        float4 _SnowDirection;
        float _SnowDepth;
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Bump;
            float3 worldNormal;
            INTERNAL_DATA
        };
        
        void vert(inout appdata_full v)
        {
            float4 sn = mul(_SnowDirection, unity_WorldToObject);
            if (dot(v.normal, sn.xyz) >= _SnowLevel)
                v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _SnowLevel;
        }
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            
            if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _SnowLevel)
                o.Emission = _SnowColor.rgb;
            else
                o.Emission = c.rgb * _MainColor;
            
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}