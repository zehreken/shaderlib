Shader "ShaderLib/DiffuseDistance"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" { }
		_Center ("Center", Vector) = (0, 0, 0, 0)
		_Radius ("Radius", Float) = 0.5
	}
	SubShader
	{
		Tags
		{
		    "RenderType" = "Opaque"
		}
		
		CGPROGRAM
		#pragma surface surf Lambert
		
		struct Input
		{
			float2 uv_MainTex;
			float3 worldPos; // This is calculated by Unity
		};
		
		sampler2D _MainTex;
		float3 _Center;
		float _Radius;

		void surf (Input IN, inout SurfaceOutput o)
		{
			float d = distance(_Center, IN.worldPos);
			float dN = 1 - saturate(d / _Radius); // Distance is normalized
			
			if (dN > 0 && dN < 1)
				o.Albedo = half3(1, 1, 0);
			else
				o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}

		ENDCG
	} 
	Fallback "Diffuse"
}