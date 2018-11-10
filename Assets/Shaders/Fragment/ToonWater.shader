﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderLib/ToonWater"
{
	Properties 
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" { }
		_Colour ("Colour", Color) = (1, 1, 1, 1)

		_BumpMap ("Noise text", 2D) = "bump" { }
		_Magnitude ("Magnitude", Range(0, 1)) = 0.05
		_Noisetex ("Noise texture", 2D) = "bump" { }
		_offset ("offset", Range(0, 1)) = 0.05
		_waterMagnitude ("Water Magnitude", Range(0, 1)) = 0.05
		_waterPeriod ("Water Period", Range(0, 1)) = 0.05
		_CausticTex ("Caustic", 2D) = "white" { }
		_waterColour ("Colour", Color) = (1, 1, 1, 1)
		_causticColour ("Colour", Color) = (1, 1, 1, 1)
	}
	
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque"}
		ZWrite On Lighting Off Cull Off Fog { Mode Off } Blend One Zero

		GrabPass
		{
		    "_GrabTexture"
		}
		
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;

			sampler2D _MainTex;
			fixed4 _Colour;

			sampler2D _BumpMap;
			float  _Magnitude;
			sampler2D _NoiseTex;
			float _offset;
			float _waterMagnitude;
			float _waterPeriod;
			sampler2D _CausticTex;
			fixed4 _waterColour;
			fixed4 _causticColour;

			struct vin_vct
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f_vct
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;

				float4 uvgrab : TEXCOORD1;
			};

			// Vertex function 
			v2f_vct vert (vin_vct v)
			{
				v2f_vct o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;

				o.texcoord = v.texcoord;

				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}

            float2 sinusoid (float2 x, float2 m, float2 M, float2 p)
            {
            	float2 e   = M - m;
            	float2 c = 3.1415 * 2.0 / p;
            	return e / 2.0 * (1.0 + sin(x * c)) + m;
            }
			
			// Fragment function
            fixed4 frag (v2f_vct i) : COLOR
            {
	            fixed4 noise = tex2D(_NoiseTex, i.texcoord);
	            fixed4 mainColour = tex2D(_MainTex, i.texcoord);
			
	            float time = _Time[1];

	            float2 waterDisplacement = sinusoid
	            (
	            	float2(time, time) + (noise.xy) * _offset,
	            	float2(-_waterMagnitude, -_waterMagnitude),
	            	float2(+_waterMagnitude, +_waterMagnitude),
	            	float2(_waterPeriod, _waterPeriod)
	            );
				
	            i.uvgrab.xy += waterDisplacement;
	            fixed4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
	            fixed4 causticColour = tex2D(_CausticTex, i.texcoord.xy*0.25 + waterDisplacement*5);
	            return col * mainColour * _waterColour * causticColour;
            }
		
			ENDCG
		}
	}
}