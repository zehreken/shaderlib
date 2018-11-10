// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderLib/Distortion" 
{
	Properties 
	{
		_Distortion ("Distortion", Range(-1, 1)) = 10
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}
	SubShader 
	{
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }

		GrabPass 
		{
			Name "BASE"
		}

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA

			#include "UnityCG.cginc"

			struct vertexInput 
			{
				float4 pos : POSITION;
				float2 texcoord: TEXCOORD0;
			};

			struct vertexOutput 
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float2 uvbump : TEXCOORD1;
			};

			uniform sampler2D _GrabTexture;
			uniform sampler2D _BumpMap;

			uniform float4 _BumpMap_ST;

			uniform float _Distortion;

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.pos);

				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				o.uv.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
				o.uv.zw = o.pos.zw;

				o.uvbump = TRANSFORM_TEX( v.texcoord, _BumpMap );

				return o;
			}

			half4 frag(vertexOutput i) : COLOR
			{
				half2 bump = UnpackNormal(tex2D( _BumpMap, i.uvbump )).rg;
				fixed offset = bump * _Distortion;
				i.uv.x = offset * i.uv.z + i.uv.x;
	
				half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv));
				return col;
			}
			ENDCG
		}
	}
	// Add Fallback
}