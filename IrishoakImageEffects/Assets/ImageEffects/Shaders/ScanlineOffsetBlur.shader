Shader "Hidden/irishoak/ImageEffects/ScanlineOffsetBlur" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Offset;
	uniform float _ScanLineNum;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv;
		
		if (sin(uv.y * 3.1415 * _ScanLineNum) > 0.0) {
			uv.x -= _Offset;
		} else {
			uv.x += _Offset;
		}
		
		return tex2D(_MainTex, uv);;
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