// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float3 _WorldSpaceCameraPos', a built-in variable
// Upgrade NOTE: commented out 'float4 unity_ShadowFadeCenterAndType', a built-in variable

Shader "Unlit/AlloyPBR"
{
	Properties
	{
		_Color ("_Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_SpecTex ("_SpecTex", 2D) = "white" {}
		_BumpMap ("_BumpMap", 2D) = "bump" {}
		unity_SpecCube ("Texture", CUBE) = "white" {}
		_Roughness ("_Roughness", Range(0, 1)) = 0
		_Metal ("_Metal", Range(0, 1)) = 0
		_Specularity ("_Specularity", Range(0, 1)) = 0
		_BaseColorVertexTint ("_BaseColorVertexTint", Float) = 1
		_LightColor0("_LightColor0",Color) = (1,1,1,1)
		_Occlusion("Occlusion", Range(0, 1)) = 0
		 _ShadowMapTexture ("_ShadowMapTexture", 2D) = "white" {}

		
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
			
		
			#include "../CGIncludes/RolantinCG.cginc"

			struct vertexin
			{

				//in  float4 in_POSITION0;
				float4 vertex : POSITION;
				//in  float4 in_TEXCOORD0;
				float2 uv0 : TEXCOORD0;				
				//in  float4 in_TEXCOORD1;
				float2 uv1:TEXCOORD1;
				//in  float3 in_NORMAL0;
				float3 normal:NORMAL;
				//in  float4 in_TANGENT0;
				float4 color:COLOR;
				//in  float4 in_COLOR0;
				float4 tangent: TANGENT;
								
			};

			struct vertexout
			{
				float4 pos : SV_POSITION;
				float3 normal:TEXCOORD2;
				float2 uv : TEXCOORD0;
				float2 uv1: TEXCOORD1;
				float3 normaldir: TEXCOORD3;
				float4 uvsave:TEXCOORD4;
				float4 tangentdir:TEXCOORD5;
				float4 vectorcolor:TEXCOORD6;
				float4 posWorld:TEXCOORD7;
				float4 vs_TEXCOORD0:TEXCOORD8;
				float4 vs_TEXCOORD6:TEXCOORD9;
				float4 vs_TEXCOORD5:TEXCOORD10;
				         float3 tangentDir: TEXCOORD11;
                float3 bitangentDir: TEXCOORD12;

			};

			
			

			//float4 unity_SHBr;
			//float4 unity_SHBg;
			//float4 unity_SHBb;
			//float4 unity_SHC;
			float4 hlslcc_mtx4x4unity_ObjectToWorld[4];
			float4 hlslcc_mtx4x4unity_WorldToObject[4];
			//float4 unity_WorldTransformParams;
			float4 hlslcc_mtx4x4unity_MatrixVP[4];


		//	float4 _Time;
			// float3 _WorldSpaceCameraPos;
		//	float4 _WorldSpaceLightPos0;
//			float4 unity_SHAr;
		//	float4 unity_SHAg;
		//	float4 unity_SHAb;
			float4 hlslcc_mtx4x4unity_WorldToShadow[16];
//			float4 _LightShadowData;
			// float4 unity_ShadowFadeCenterAndType;
			float4 hlslcc_mtx4x4unity_MatrixV[4];
//			float4 unity_SpecCube0_HDR;
			float4 _LightColor0;
			float4 _Color;
//			float4 _MainTex_ST;
			float2 _MainTexVelocity;
			float _MainTexUV;
			float _BaseColorVertexTint;
			float _Metal;
			float _Specularity;
			float _SpecularTint;
			float _Roughness;
			float _Occlusion;
			float _BumpScale;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SpecTex;
			sampler2D _BumpMap;
			samplerCUBE unity_SpecCube;
			//samplerCUBE unity_SpecCube0;
			//sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
			sampler2D hlslcc_zcmp_ShadowMapTexture;
			sampler2D _ShadowMapTexture;
			
			vertexout vert (vertexin v)
			{
				vertexout o =(vertexout)0 ;

				float3 u_xlat0;
				float4 u_xlat1;
				float u_xlat16_1;
				float4 u_xlat2;
				float4 u_xlat16_2;
				float3 u_xlat16_3;
				float3 u_xlat4;
				float u_xlat15;

				float4 vs_TEXCOORD0;
				float4 vs_TEXCOORD1;
				//float4 VertexColor;
				float4 posWorld;
				float4 vs_TEXCOORD4;
				float3 vs_TEXCOORD5;
				float3 vs_TEXCOORD6;
				float3 vs_TEXCOORD7;



			//u_xlat0.x = dot(NORMAL, hlslcc_mtx4x4unity_WorldToObject[0].xyz);
			//u_xlat0.y = dot(NORMAL, hlslcc_mtx4x4unity_WorldToObject[1].xyz);
			//u_xlat0.z = dot(NORMAL, hlslcc_mtx4x4unity_WorldToObject[2].xyz);
			//u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
			//u_xlat15 = inversesqrt(u_xlat15);

			//u_xlat0.xyz = float3(u_xlat15) * u_xlat0.xyz;  
			o.normaldir = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
			o.vectorcolor = v.color;
			//u_xlat0.xyz = normaldir;

			//cross
			//c = a×b = （a.y*b.z-b.y*a.z , b.x*a.z-a.x*b.z , a.x*b.y-b.x*a.y）


			u_xlat16_1 = o.normaldir.y * o.normaldir.y;

			u_xlat16_1 = o.normaldir.x * o.normaldir.x + (-u_xlat16_1);

			u_xlat16_2 = o.normaldir.yzzx * o.normaldir.xyzz;

			u_xlat16_3.x = dot(unity_SHBr, u_xlat16_2);
			u_xlat16_3.y = dot(unity_SHBg, u_xlat16_2);
			u_xlat16_3.z = dot(unity_SHBb, u_xlat16_2);

			vs_TEXCOORD0.xyz = unity_SHC.xyz * u_xlat16_1 + u_xlat16_3.xyz;
			vs_TEXCOORD0.w = 0.0;
			o.vs_TEXCOORD0 = vs_TEXCOORD0;
			vs_TEXCOORD1 = float4(0.0, 0.0, 0.0, 0.0);

			//u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.x + u_xlat1;
			//u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[1] * in_POSITION0.y;			
			//u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.z + u_xlat1;
			//u_xlat2 = u_xlat1 + hlslcc_mtx4x4unity_ObjectToWorld[3];
			//posWorld.xyz = hlslcc_mtx4x4unity_ObjectToWorld[3].xyz * in_POSITION0.www + u_xlat1.xyz;
			//posWorld.w = 0.0;

			    o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
                o.bitangentDir = normalize(cross(o.normaldir, o.tangentDir) * v.tangent.w);
             

			o.posWorld = mul(unity_ObjectToWorld,v.vertex);

			//u_xlat1 = u_xlat2.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
			//u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat2.xxxx + u_xlat1;
			//u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat2.zzzz + u_xlat1;
			//gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat2.wwww + u_xlat1;

			o.pos = UnityObjectToClipPos(v.vertex);//o.pos = UnityObjectToClipPos(v.vertex);


			//u_xlat4.xyz = in_COLOR0.xyz * float3(0.305306017, 0.305306017, 0.305306017) + float3(0.682171106, 0.682171106, 0.682171106);
			//u_xlat4.xyz = in_COLOR0.xyz * u_xlat4.xyz + float3(0.0125228781, 0.0125228781, 0.0125228781);
			//u_xlat4.xyz = u_xlat4.xyz * in_COLOR0.xyz;
			//VertexColor.xyz = u_xlat4.xyz;
			//VertexColor.w = in_COLOR0.w;

			o.vectorcolor = v.color;

			o.uvsave.xy = v.uv0;
			o.uvsave.zw = v.uv1;

			u_xlat4.xyz = v.tangent.y * hlslcc_mtx4x4unity_ObjectToWorld[1].xyz;
			u_xlat4.xyz = hlslcc_mtx4x4unity_ObjectToWorld[0].xyz * v.tangent.x + u_xlat4.xyz;
			u_xlat4.xyz = hlslcc_mtx4x4unity_ObjectToWorld[2].xyz * v.tangent.z + u_xlat4.xyz;



			u_xlat15 = dot(u_xlat4.xyz, u_xlat4.xyz);
			u_xlat15 = rsqrt(u_xlat15);
			u_xlat4.xyz = u_xlat15 * u_xlat4.xyz;
			o.vs_TEXCOORD5.xyz = u_xlat4.xyz;

			u_xlat16_3.xyz = o.normaldir.zxy * u_xlat4.yzx;
			u_xlat16_3.xyz = o.normaldir.yzx * u_xlat4.zxy + (-u_xlat16_3.xyz);

			vs_TEXCOORD7.xyz = o.normaldir.xyz;
			u_xlat0.x = v.tangent.w * unity_WorldTransformParams.w;

			o.vs_TEXCOORD6.xyz = o.normaldir.xxx * u_xlat16_3.xyz;


              
            
             
		

				return o;
			}
			
			fixed4 frag (vertexout i) : SV_Target
			{


				  float4 vs_TEXCOORD0 = i.vs_TEXCOORD0;
				
				   float4 posworld =i.posWorld;
				 
				  float4 vs_TEXCOORD4;
				  float3 vs_TEXCOORD5 = i.vs_TEXCOORD5;
				  float3 vs_TEXCOORD6= i.vs_TEXCOORD6;
				  float3 vs_TEXCOORD7 = i.normaldir;


				
				 float4 u_xlat16_0;
			
				bool u_xlatb0;
				
				 
				
				
				
			
				float3 u_xlat5;
				
			
				 float3 u_xlat16_6;
				
				
				 float3 u_xlat16_9;
				 float3 u_xlat16_10;
				 float3 rename;
				
				 float2 u_xlat16_13;
				float u_xlat14;
				 float u_xlat16_14;
				 float u_xlat10_14;
				 
				 float u_xlat16_19;
				 float u_xlat16_20;
				
				
				bool u_xlatb28;
				
			
			
			
				 float u_xlat16_47;
				 float u_xlat16_50;


				

				#ifdef UNITY_ADRENO_ES3
				u_xlatb0 = !!(_MainTexUV<0.5);
				#else
				u_xlatb0 = _MainTexUV<0.5;
				#endif
				float2 uv = (bool(u_xlatb0)) ? i.uvsave.xy : i.uvsave.zw;
				float2 uvpos = _MainTexVelocity.xy * _Time.yy + _MainTex_ST.zw;
				uvpos = uvpos.xy / _MainTex_ST.xy;
				uv = uvpos.xy + uv.xy;
				uv = uv * _MainTex_ST.xy;
//normalmapping
				float3 normalmap_var = UnpackNormal (tex2D(_BumpMap, uv));
			//	float4 normaldir = float4 (normalmap_var.xy  * _BumpScale,normalmap_var.z,1);
				

				//float4 u_xlat16_3;
				//u_xlat16_3.xyz = normaldir.y * vs_TEXCOORD6.xyz;
				//normaldir.xyw =  normaldir.x * vs_TEXCOORD5.xyz + u_xlat16_3.xyz;
				//normaldir.xyz =  normaldir.z * vs_TEXCOORD7.xyz + normaldir.xyw;

				float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normaldir);
				float3 normalDirection = normalize(mul(normalmap_var, tangentTransform)); 

				//return  float4(normalDirection,1);

				


				//float u_xlat16_44 = dot(normaldir, normaldir);
				//u_xlat16_44 = rsqrt(u_xlat16_44);
			   // float4 u_xlat16_1;
			   // u_xlat16_1.xyz = u_xlat16_44 * normaldir;
				float4 normaldirection;
				normaldirection.xyz = normalize(normalDirection);

				float3 viewDir = normalize( posworld - _WorldSpaceCameraPos.xyz);

				

				float u_xlat28 = dot(viewDir, viewDir);
				u_xlat28 = rsqrt(u_xlat28);
				//u_xlat5.xyz = u_xlat28 * viewDir;

				float3 viewReflectDirection = reflect( -viewDir, normaldirection );

				//normaldir.x = dot((-viewDir), normaldirection);
				//normaldir.x = normaldir.x + normaldir.x;
				//normaldir.xyz = normaldirection * (-normaldir.x) + (-viewDir);

				//float NdotL = dot(-LightDir0, viewReflectDirection);

				//u_xlat16_6.xyz = (NdotL * viewReflectDirection) + LightDir0;

				float H = normalize( viewReflectDirection + -LightDir0);

				//float x16 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
				//x16 = rsqrt(x16);

				float lightw_dis = abs(_LightColor0.w) ;

				H = H * lightw_dis;

				H = min(H, 1.0);

				H = H * H  -LightDir0;

				float x12 = dot(H, H);
				x12 = rsqrt(x12);
				float4 u_xlat16_3;
				 u_xlat16_3.rgb = H * x12 + viewDir;
				//H = x12 * H;


				float ds = dot(normaldirection, viewDir);
				ds = clamp(ds, 0.0, 1.0);
			
				float u_xlat16_45;
				u_xlat16_45 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
				u_xlat16_45 = rsqrt(u_xlat16_45);
				u_xlat16_3.xyz =u_xlat16_45 * u_xlat16_3.xyz;

				u_xlat16_45 = dot(normaldirection, u_xlat16_3.xyz);


			
			
				u_xlat16_45 = clamp(u_xlat16_45, 0.0, 1.0);
		
				u_xlat16_3.x = dot(H, u_xlat16_3.xyz);

			
				u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
			
				float u_xlat16_17 = u_xlat16_45 * u_xlat16_45;


				float4 diffuse_var = tex2D(_MainTex, uv) /3.14;
				float4 specmap_var = tex2D(_SpecTex, uv);
		
				float metall_gloss = specmap_var.a * _Roughness;

				float ngloss = metall_gloss;
				float gloss2 = ngloss * ngloss;
				ngloss = gloss2 * gloss2 -1.0;
				ngloss = u_xlat16_17 * ngloss + 1.0;
				u_xlat16_17 = u_xlat16_3.x * u_xlat16_3.x;

				

				float gloss4 = gloss2 * gloss2;

				u_xlat16_47 = (-gloss4) * 0.25 + 1.0;
				float gloss5 = gloss4 * 0.25;
				u_xlat16_47 = u_xlat16_17 * u_xlat16_47 + gloss5;
				u_xlat16_20 = u_xlat16_17 + u_xlat16_17;
				u_xlat16_20 = u_xlat16_20 * metall_gloss + -0.5;
				u_xlat16_17 = ngloss * u_xlat16_47;
				u_xlat16_17 = ngloss * u_xlat16_17;
				u_xlat16_17 = gloss5 / u_xlat16_17;

			
				ngloss = specmap_var.g * ngloss  -1.0;
				ngloss = _Occlusion * ngloss + 1.0;
				gloss4 = ds + ngloss;
				u_xlat16_19 = gloss4 * gloss4 + -1.0;
				u_xlat16_19 = ngloss + u_xlat16_19;
				
				u_xlat16_19 = clamp(u_xlat16_19, 0.0, 1.0);
			
				u_xlat16_17 = u_xlat16_17 * u_xlat16_19;
				x12 = lightw_dis * x12 + gloss2;
				x12 = min(x12, 1.0);
				x12 = gloss2 / x12;
				gloss2 = x12 * x12;
			
				u_xlatb28 = 0.0<_LightColor0.w;
			
				u_xlat28 = (u_xlatb28) ? gloss2 : 0.0;
				u_xlat16_17 = u_xlat28 * u_xlat16_17;
				float vb  = u_xlat16_3.x * -5.55472994 + -6.98316002;
				vb = u_xlat16_3.x * vb;
				vb = exp2(vb);

				float3 combinecolor;
		
				combinecolor.xyz = _BaseColorVertexTint * _Color.xyz*diffuse_var;


				
				combinecolor = clamp(combinecolor, 0.0, 1.0);
			
				u_xlat16_3.x = dot(combinecolor, float3(0.212599993, 0.715200007, 0.0722000003));
				u_xlat16_0.x = max(u_xlat16_3.x, 10);
				u_xlat16_0.xyw = combinecolor / u_xlat16_0.x;

				float specmap_b =  specmap_var.b *_Specularity;

				//return float4 (u_xlat16_0.xyw,1);
				u_xlat16_9.xyz =( (u_xlat16_0.xyw + float3(-1.0, -1.0, -1.0)) * _SpecularTint + float3(1.0, 1.0, 1.0)) *specmap_b;
				
//todo
				
				u_xlat16_0.x = (-_Metal) * specmap_var.x + 1.0;
				u_xlat16_10.xyz = u_xlat16_0.xxx * combinecolor;

				combinecolor = specmap_var.r * _Metal * (-specmap_b * u_xlat16_9.xyz + combinecolor) + u_xlat16_9.xyz;

				u_xlat16_9.xyz = (-combinecolor) + float3(1.0, 1.0, 1.0);
				u_xlat16_9.xyz = vb * u_xlat16_9.xyz + combinecolor;
				u_xlat16_3.xyw =u_xlat16_17 * u_xlat16_9.xyz;
				u_xlat16_50 = dot(normaldirection, -LightDir0);
				
				u_xlat16_50 = clamp(u_xlat16_50, 0.0, 1.0);
			
				u_xlat16_0.x = u_xlat16_50 * -5.55472994 + -6.98316002;
				u_xlat16_0.x = u_xlat16_50 * u_xlat16_0.x;
				u_xlat16_0.x = exp2(u_xlat16_0.x);
				u_xlat16_0.x = u_xlat16_0.x * u_xlat16_20 + 1.0;
				u_xlat16_14 = ds * -5.55472994 + -6.98316002;
				u_xlat16_14 = ds * u_xlat16_14;
				float dc  = ds * -9.27999973;
				dc = exp2(dc);
				u_xlat16_14 = exp2(u_xlat16_14);
				u_xlat16_14 = u_xlat16_14 * u_xlat16_20 + 1.0;
				float3 ffl = u_xlat16_14 * u_xlat16_0.x;
				u_xlat16_3.xyw = u_xlat16_10.xyz * ffl + u_xlat16_3.xyw;

				float3 u_xlat6;
				u_xlat6.x = hlslcc_mtx4x4unity_MatrixV[0].z;
				u_xlat6.y = hlslcc_mtx4x4unity_MatrixV[1].z;
				u_xlat6.z = hlslcc_mtx4x4unity_MatrixV[2].z;

				uv.x = dot(viewDir, u_xlat6.xyz);

				viewDir = posworld + (-unity_ShadowFadeCenterAndType.xyz);
				u_xlat14 = dot(viewDir, viewDir);
				u_xlat14 = sqrt(u_xlat14);
				u_xlat14 = (-uv.x) + u_xlat14;
				uv.x = unity_ShadowFadeCenterAndType.w * u_xlat14 + uv.x;

				uv.x = uv.x * _LightShadowData.z + _LightShadowData.w;
				uv.x = clamp(uv.x, 0.0, 1.0);
				
				viewDir = posworld.y * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
				viewDir = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * posworld.x + viewDir;
				viewDir = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * posworld.z + viewDir;
				viewDir = viewDir + hlslcc_mtx4x4unity_WorldToShadow[3].xyz;

				float3 txVec0 = float3(viewDir.xy,viewDir.z);

				u_xlat10_14 = tex2Dlod(hlslcc_zcmp_ShadowMapTexture, float4(txVec0,0));
				float fff  = (-_LightShadowData.x) + 1.0;
				fff = u_xlat10_14 * fff + _LightShadowData.x;
				fff = uv.x + fff;
				
				fff = clamp(fff, 0.0, 1.0);
				
				fff = u_xlat16_50 * fff;
				u_xlat16_3.xyw = u_xlat16_3.xyw * fff;
				normaldirection.w = 1.0;
				u_xlat16_9.x = dot(unity_SHAr, normaldirection);
				u_xlat16_9.y = dot(unity_SHAg, normaldirection);
				u_xlat16_9.z = dot(unity_SHAb, normaldirection);
				u_xlat16_9.xyz = u_xlat16_9.xyz + vs_TEXCOORD0.xyz;
				u_xlat16_9.xyz = max(u_xlat16_9.xyz, float3(0.0, 0.0, 0.0));
				u_xlat16_0.xyw = log2(u_xlat16_9.xyz);
				u_xlat16_0.xyw = u_xlat16_0.xyw * float3(0.416666657, 0.416666657, 0.416666657);
				u_xlat16_0.xyw = exp2(u_xlat16_0.xyw);
				u_xlat16_0.xyw = u_xlat16_0.xyw * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
				u_xlat16_0.xyw = max(u_xlat16_0.xyw, float3(0.0, 0.0, 0.0));
				u_xlat16_9.xyz = ngloss * u_xlat16_0.xyw;
				rename.xyz = combinecolor * u_xlat16_9.xyz;

				float blur = ((-metall_gloss) * 0.7 + 1.7) * metall_gloss* 6.0 ;
				float4 ddk= metall_gloss * float4(-1.0, -0.0274999999, -0.572000027, 0.0219999999) + float4(1.0, 0.0425000004, 1.03999996, -0.0399999991);
			
				float4 SPL = texCUBElod(unity_SpecCube, float4(-viewReflectDirection, blur)).rgba;
				
				
				metall_gloss = (unity_SpecCube0_HDR.w * (SPL.w -1.0) + 1.0) * unity_SpecCube0_HDR.x ;
				
				float3 SPLMETALL;
				SPLMETALL.xyz = SPL.xyz * metall_gloss;
				metall_gloss = ddk.x * ddk.x;
				u_xlat16_0.x = min(dc, metall_gloss);
				u_xlat16_0.x = u_xlat16_0.x * ddk.x + ddk.y;
				u_xlat16_13.xy = u_xlat16_0.x * float2(-1.03999996, 1.03999996) + ddk.zw;
				combinecolor = combinecolor * u_xlat16_13.xxx + u_xlat16_13.yyy;
				combinecolor =  SPLMETALL.xyz * combinecolor + (-rename.xyz);
				combinecolor = u_xlat16_19* combinecolor + rename.xyz;
				combinecolor = u_xlat16_9.xyz * u_xlat16_10.xyz + combinecolor;

				float4 finalcolor;
				finalcolor.xyz = LightColor0  * LightIntensity0 * u_xlat16_3.xyw + combinecolor;
			
				finalcolor.w = 1.0;

				return float4(finalcolor);
			}
			ENDCG
		}
	}
}









