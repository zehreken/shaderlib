// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderLib/PlainColor"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 0)
    }
    
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert             
            #pragma fragment frag
            
            half4 _Color;
        
            struct vertInput
            {
                float4 pos : POSITION;
            };  
        
            struct vertOutput
            {
                float4 pos : SV_POSITION;
            };
        
            vertOutput vert(vertInput input)
            {
                vertOutput o;
                o.pos = UnityObjectToClipPos(input.pos);
                return o;
            }
        
            half4 frag(vertOutput output) : COLOR
            {
                return _Color;
            }
            ENDCG
        }
    }
}