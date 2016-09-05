Shader "Custom/funamushi" {
    Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_PosParam("Position param", Range (0.0,1.0)) = 0.0
    }
	SubShader {
   		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha // alpha blending
		
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
 			#pragma target 3.0
 			
 			#include "UnityCG.cginc"

            uniform sampler2D _MainTex;
			float _PosParam;

 			struct appdata_custom {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

 			struct v2f {
 				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
 			};
 			
 			//float4x4 _PrevInvMatrix;
			//float3   _TargetPosition;
			//float    _Range;
			//float    _RangeR;
			//float    _Size;
			//float3   _MoveTotal;
			//float3   _CamUp;
   
            v2f vert(appdata_custom v)
            {
				//float3 target = _TargetPosition;
				//float3 trip;
				//float3 mv = v.vertex.xyz;
				//mv += _MoveTotal;
				//trip = floor( ((target - mv)*_RangeR + 1) * 0.5 );
				//trip *= (_Range * 2);
				//mv += trip;
				//
				//float3 diff = _CamUp * _Size;
				float3 finalposition = v.vertex.xyz;
				//float3 tv0 = mv;
				//tv0.x += sin(mv.x*0.2) * sin(mv.y*0.3) * sin(mv.x*0.9) * sin(mv.y*0.8);
				//tv0.z += sin(mv.x*0.1) * sin(mv.y*0.2) * sin(mv.x*0.8) * sin(mv.y*1.2);
				//{
				//	float3 eyeVector = ObjSpaceViewDir(float4(tv0, 0));
				//	float3 sideVector = normalize(cross(eyeVector,diff));
				//	tv0 += (v.texcoord.x-0.5f)*sideVector * _Size;
				//	tv0 += (v.texcoord.y-0.5f)*diff;
				//	finalposition = tv0;
				//}

				//float3 pos = v.vertex.xyz + v.vertex.xyz * _PosParam * 10.0f;
				float3 pos = v.vertex.xyz * ( 1.0f + _PosParam * 10.0f);

				float rot = atan2(pos.x, -pos.z);
				float sinX = sin(rot);//sin( _RotationSpeed * _Time.z );
				float cosX = cos(rot);//cos( _RotationSpeed * _Time.z );
				float sinY = sin(rot);//sin( _RotationSpeed * _Time.z );
				float2x2 rotationMatrix = float2x2( cosX, -sinX, sinY, cosX);
            	
				
				v2f o;
			
				float3 tv0 = float3((v.texcoord.x - 0.5f) * 3.0f, 0.0f, (v.texcoord.y - 0.5f) * 3.0f);
				
				tv0.xz = mul(rotationMatrix, tv0.xz);
				tv0 += pos.xyz;

			    o.pos = mul( UNITY_MATRIX_MVP, float4(tv0,1));
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
