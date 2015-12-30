
// I used below code as reference.
// [Shadertoy] Mrs Scary
// https://www.shadertoy.com/view/ldB3Dh

Shader "Hidden/irishoak/ImageEffects/MrsScary" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Rotation;
			
	float2x2 RotateMat(float angle){
		float si = sin(angle);
		float co = cos(angle);
		return float2x2(co, si, -si, co);
	}

	float3 Colour(in float h) {
		h = frac(h);
		return clamp((abs(frac(h + float3(3.0, 2.0, 1.0) / 3.0) * 6.0 - 3.0) - 1.0), 0.0, 1.0);
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv   = i.uv;
		float  time = _Time.y;

		float2 pixel = (uv.xy - float2(0.5, 0.5));
		float3 col;
		float  n;
		
		float inc = _Rotation;
		
		float2x2 rotMat =  RotateMat(inc);
		for (int i = 1; i < 50; i++)
		{
			pixel = mul(rotMat, pixel);
			float  depth = 40.0 + float(i);
			float2 uv    = pixel * depth / 210.0;
			
			col = tex2D(_MainTex, frac(uv + float2(0.5, 0.5))).rgb;
			
			if ((1.0 - (col.y * col.y)) < float(i + 1) / 50.0)
			{
				break;
			}

		}
		col = min(col * col * 1.5, 1.0);
		
		return fixed4(col.xzy, 1.0);
	}
	
	ENDCG
	
	
	SubShader {
		
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
			CGPROGRAM
			#pragma target 3.0
			#pragma glsl
			#pragma vertex   vert_img
			#pragma fragment frag
			ENDCG
		} 
	}
	FallBack "Diffuse"
}