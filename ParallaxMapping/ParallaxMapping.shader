Shader "Unlit/ParallaxMapping"
{
	Properties
	{

		_Tiling("Tiling", Float) = 4

		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Parallax("Parallax", Range( 0 , 0.1)) = 0
		_HeightMap("HeightMap", 2D) = "white" {}

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

			struct vertexin
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			struct vertexout
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				//float3 tSpace0:TEXCOORD1;
				//float3 tSpace2:TEXCOORD2;
				//float3 tSpace1:TEXCOORD3;
				float3 viewDir:TEXCOORD4;
				float3	worldNormal:TEXCOORD5 ;
				float3	 worldBinormal:TEXCOORD6;
				float3	worldTangent:TEXCOORD7;


			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
	
			fixed _Tiling;
			uniform sampler2D _HeightMap;
		    uniform float4 _HeightMap_ST;
		    uniform fixed _Parallax;
			uniform sampler2D _Normal;
			uniform sampler2D _Albedo;

			vertexout vert (vertexin v)
			{

				vertexout o = (vertexout)0;
				o.uv = v.uv;
				float3 worldpos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o. worldNormal = UnityObjectToWorldNormal(v.normal);
				o. worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;


				o. worldBinormal = cross(o.worldNormal,o.worldTangent)*tangentSign;

				float3 worldviewdir = normalize (_WorldSpaceCameraPos - worldpos);

				float3 tSpace0 = float4( o.worldTangent.x, o. worldBinormal.x, o. worldNormal.x, worldpos.x );
				float3 tSpace1 = float4( o.worldTangent.y, o. worldBinormal.y, o. worldNormal.y, worldpos.y );
				float3 tSpace2 = float4( o.worldTangent.z, o. worldBinormal.z, o. worldNormal.z, worldpos.z );

				o.viewDir =  tSpace0.xyz*worldviewdir.x + tSpace1.xyz*worldviewdir.y + tSpace2.xyz*worldviewdir.z;

				o.vertex = UnityObjectToClipPos(v.vertex);
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (vertexout i) : SV_Target
			{
				// sample the texture
				//float3 worldpos = float3(i.tSpace0.w,i.tSpace1.w,i.tSpace2.w);
			
				//float3 viewDir = i.tSpace0.xyz*worldviewdir.x + i.tSpace1.xyz*worldviewdir.y + i.tSpace2.xyz*worldviewdir.z;

			
              float3x3 tangentTransform = float3x3( i.worldTangent, i.worldBinormal, i.worldNormal);

           
 

			    float2 uv_HeightMap = i.uv * _HeightMap_ST.xy + _HeightMap_ST.zw;
				float2 Offset4 = ( ( tex2D( _HeightMap, uv_HeightMap ).r - 1 ) * i.viewDir.xy * _Parallax ) + (i.uv*_Tiling);
		     	float2 Offset49 = ( ( tex2D( _HeightMap, Offset4 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset4;
			    float2 Offset52 = ( ( tex2D( _HeightMap, Offset49 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset49;
			    float2 Offset54 = ( ( tex2D( _HeightMap, Offset52 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset52;

			     float4 diffuse_var = tex2D(_Albedo,Offset54);
			     float3 normal_var = UnpackNormal(tex2D(_Normal,Offset54));

			   
			       float3 normalDirection = normalize(mul( normal_var, tangentTransform ));

			     float3 light = DirectionalLight(normalDirection)[0];

			     float3 coo = light * diffuse_var;

			  


				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return float4(coo,1);
			}
			ENDCG
		}
	}
}
