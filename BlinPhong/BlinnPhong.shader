Shader "Unlit/BlinnPhong"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "../CGIncludes/RolantinCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal :NORMAL;

			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3	pos : TEXCOORD1;
				float3	 nordir:TEXCOORD3 ;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.nordir = UnityObjectToWorldDir(v.normal);
				o.pos = mul (unity_ObjectToWorld , v.vertex	);


				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
                float3	Light = DirectionalLight(i.nordir)[0];
				float3 viewDir = (_WorldSpaceCameraPos- i.pos);
				float3 H = normalize( -LightDir0 + viewDir) ;



				float3 F =saturate(dot(i.nordir,H));

				float specPow = exp2( 10 + 1 ) ;  
				float3 fianl =  max(0 ,pow(F,10)) ;

				fixed4 col = tex2D(_MainTex, i.uv) + fianl.rgbb *Light.rgbb  ;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
