Shader "Hidden/irishoak/ImageEffects/InverseColor" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	uniform float     _Value;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		fixed3 col = tex2D(_MainTex, i.uv).xyz;
		return fixed4(lerp(col, 1.0 - col, _Value), 1.0);
	}
	
	ENDCG
	
	
	SubShader {
		
		Pass {
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