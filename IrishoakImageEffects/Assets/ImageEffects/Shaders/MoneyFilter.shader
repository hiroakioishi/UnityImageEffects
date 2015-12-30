
// This is port of below code.
// [Shadertoy] Money filter
// https://www.shadertoy.com/view/XlsXDN
// Uploaded by giacomo in 2015-Jul-20

Shader "Hidden/irishoak/ImageEffects/MoneyFilter" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Frecuencia = 10;
	uniform float _Divisor    = 0.0075;
	uniform float _Gain       = 1.0;
	
	uniform float _Value;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
	
	  	float2 xy = i.uv.xy;
    
		float amplitud   = 0.03;
		float frecuencia = _Frecuencia;
		float gris       = 1.0;
		float divisor    = _Divisor;
		float grosorInicial = divisor * 0.2;

		const int kNumPatrones = 6;

		// x: seno del angulo, y: coseno del angulo, z: factor de suavizado
		float3 datosPatron[kNumPatrones];
		datosPatron[0] = float3(-0.7071, 0.7071, 3.0); // -45
		datosPatron[1] = float3(0.0, 1.0, 0.6); // 0
		datosPatron[2] = float3(0.0, 1.0, 0.5); // 0
		datosPatron[3] = float3(1.0, 0.0, 0.4); // 90
		datosPatron[4] = float3(1.0, 0.0, 0.3); // 90
		datosPatron[5] = float3(0.0, 1.0, 0.2); // 0

		fixed4 color = tex2D(_MainTex, float2(xy));
		//fragColor = color;

		for(int i = 0; i < kNumPatrones; i++)
		{
		    float coseno = datosPatron[i].x;
		    float seno = datosPatron[i].y;
		    
		    // Rotación del patrón
		    float2 punto = float2(
		        xy.x * coseno - xy.y * seno,
		        xy.x * seno + xy.y * coseno
		    );

		    float grosor = grosorInicial * float(i + 1);
		    float dist = fmod(punto.y + grosor * 0.5 - sin(punto.x * frecuencia) * amplitud, divisor);
		    float brillo = 0.3 * color.r + 0.4 * color.g + 0.3 * color.b;

		    if(dist < grosor && brillo < 0.75 - 0.12 * float(i))
		    {
		        // Suavizado
		        float k = datosPatron[i].z;
		        float x = (grosor - dist) / grosor;
		        float fx = abs((x - 0.5) / k) - (0.5 - k) / k; 
		        gris = min(fx, gris);
		    }
		}
		color.rgb *= _Gain;
		return float4(color.r * gris, color.g * gris, color.b * gris, 1.0);
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