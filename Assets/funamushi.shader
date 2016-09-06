Shader "Custom/funamushi" 
{
    Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_PosParam("Position param", Range (0.0,1.0)) = 0.0
    }

	SubShader 
	{
   		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
        Pass 
		{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
 			#pragma target 3.0
 			
 			#include "UnityCG.cginc"

            uniform sampler2D _MainTex;
			float _PosParam;

 			struct appdata_custom 
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

 			struct v2f 
			{
 				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
 			};
 			
            v2f vert(appdata_custom v)
            {
				float scale = 3.0f;
				float2 pos = v.vertex.xz * (1.0f + _PosParam * 10.0f);

				float2 n = normalize(pos);
				float2 r = float2(n.y, -n.x); // right direction

				float2 v0 = (v.texcoord.x - 0.5f) * 2.0f * scale * r + (v.texcoord.y - 0.5f) * 2.0f * scale * -n;
				v0 += pos;

				v2f o;
			    o.pos = mul( UNITY_MATRIX_MVP, float4(v0.x, 0.0f, v0.y, 1.0f));
				o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
            	return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
				return tex2D(_MainTex, i.uv);
            }

            ENDCG
        }
    }
}
