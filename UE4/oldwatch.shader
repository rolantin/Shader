// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Physically-Based-Lighting" {
    Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex("Albedo-漫射贴图",2D) = "White"{}
	_BumpMap("Normal-法线贴图",2D) = "bump"{}
	_MetallicMap("MetallicMap",2D) = "Black"{}
	_NormalIntensity("法线强度", Range(0, 3)) = 1 
	_SPL("SPL",Cube) =  "Sky"{}
	 SBL_Intensity("SPL", Range(0, 10)) = 1 

	_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
	_IBL("IBL",Cube) =  "Sky"{}
	_IBL_Intensity("IBL", Range(0, 10)) = 1 

	_SpecularColor ("Specular Color", Color) = (1,1,1,1)
	//_SpecularPower("Specular Power", Range(0,1)) = 1
	//_SpecularRange("Specular Gloss",  Range(1,40)) = 0
	_HighLightPower("HighLightPower",Range(0,128)) = 1
	_Glossiness("Smoothness",Range(0,1)) = 1
	_Metallic("Metallicness",Range(0,1)) = 0
	_Anisotropic("Anisotropic",  Range(-20,1)) = 0
	_Ior("Ior",  Range(1,4)) = 1.5
	
	[KeywordEnum(BlinnPhong,U3DBlinnPhong,Phong,Beckmann,Gaussian,GGX,TrowbridgeReitzUE4,TrowbridgeReitzAnisotropic, Ward)] _NormalDistModel("Normal Distribution Model;", Float) = 0
	[KeywordEnum(AshikhminShirley,AshikhminPremoze,Duer,Neumann,Kelemen,ModifiedKelemen,Cook,Ward,Kurt)]_GeoShadowModel("Geometric Shadow Model;", Float) = 0
	[KeywordEnum(None,Walter,Beckman,GGX,Schlick,SchlickBeckman,SchlickGGX, Implicit)]_SmithGeoShadowModel("Smith Geometric Shadow Model; None if above is Used;", Float) = 0
	[KeywordEnum(Schlick,SchlickIOR, SphericalGaussian,SCHICHU3D)]_FresnelModel("Normal Distribution Model;", Float) = 0
	[Toggle] _ENABLE_NDF ("Normal Distribution Enabled?", Float) = 0
	[Toggle] _ENABLE_G ("Geometric Shadow Enabled?", Float) = 0
	[Toggle] _ENABLE_F ("Fresnel Enabled?", Float) = 0
	[Toggle] _ENABLE_D ("Diffuse Enabled?", Float) = 0

    }
    SubShader {
	Tags {
            "RenderType"="Opaque"  "Queue"="Geometry"
        } 
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "../CGIncludes/RolantinCG.cginc"

            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile _NORMALDISTMODEL_BLINNPHONG _NORMALDISTMODEL_U3DBLINNPHONG _NORMALDISTMODEL_PHONG _NORMALDISTMODEL_BECKMANN _NORMALDISTMODEL_GAUSSIAN _NORMALDISTMODEL_GGX _NORMALDISTMODEL_TROWBRIDGEREITUE4 _NORMALDISTMODEL_TROWBRIDGEREITZANISOTROPIC _NORMALDISTMODEL_WARD
            #pragma multi_compile _GEOSHADOWMODEL_ASHIKHMINSHIRLEY _GEOSHADOWMODEL_ASHIKHMINPREMOZE _GEOSHADOWMODEL_DUER_GEOSHADOWMODEL_NEUMANN _GEOSHADOWMODEL_KELEMAN _GEOSHADOWMODEL_MODIFIEDKELEMEN _GEOSHADOWMODEL_COOK _GEOSHADOWMODEL_WARD _GEOSHADOWMODEL_KURT 
            #pragma multi_compile _SMITHGEOSHADOWMODEL_NONE _SMITHGEOSHADOWMODEL_WALTER _SMITHGEOSHADOWMODEL_BECKMAN _SMITHGEOSHADOWMODEL_GGX _SMITHGEOSHADOWMODEL_SCHLICK _SMITHGEOSHADOWMODEL_SCHLICKBECKMAN _SMITHGEOSHADOWMODEL_SCHLICKGGX _SMITHGEOSHADOWMODEL_IMPLICIT
            #pragma multi_compile _FRESNELMODEL_SCHLICK _FRESNELMODEL_SCHLICKIOR _FRESNELMODEL_SPHERICALGAUSSIAN _FRESNELMODEL_SCHICHU3D 
            #pragma multi_compile  _ENABLE_NDF_OFF _ENABLE_NDF_ON
            #pragma multi_compile  _ENABLE_G_OFF _ENABLE_G_ON
            #pragma multi_compile  _ENABLE_F_OFF _ENABLE_F_ON
            #pragma multi_compile  _ENABLE_D_OFF _ENABLE_D_ON
            #pragma target 3.0
            
float4 _Color;
float4 _SpecularColor;
float _SpecularPower;
float _SpecularRange;
float _Glossiness;
float _Metallic;
float _Anisotropic;
float _Ior;
float _NormalDistModel;
float _GeoShadowModel;
float _FresnelModel;
samplerCUBE _SPL;

float _HighLightPower;
float _IBL_Intensity;
float _SPL_Intensity;
fixed4 _AmbientColor;
sampler2D _MainTex;fixed4 _MainTex_ST;
sampler2D _BumpMap;fixed4 _BumpMap_ST;
sampler2D _MetallicMap;fixed4 _MetallicMap_ST;
samplerCUBE _IBL;


#define PI 3.14

struct VertexInput {
    float4 vertex : POSITION;       //local vertex position
    float3 normal : NORMAL;         //normal direction
    float4 tangent : TANGENT;       //tangent direction    
    float2 texcoord0 : TEXCOORD0;   //uv coordinates
    float2 texcoord1 : TEXCOORD1;   //lightmap uv coordinates
};

struct VertexOutput {
    float4 pos : SV_POSITION;              //screen clip space position and depth
    float2 uv0 : TEXCOORD0;                //uv coordinates
    float2 uv1 : TEXCOORD1;                //lightmap uv coordinates

//below we create our own variables with the texcoord semantic. 
    float3 normalDir : TEXCOORD3;          //normal direction   
    float3 posWorld : TEXCOORD4;          //normal direction   
    float3 tangentDir : TEXCOORD5;
    float3 bitangentDir : TEXCOORD6;
    LIGHTING_COORDS(7,8)                   //this initializes the unity lighting and shadow
    UNITY_FOG_COORDS(9)                    //this initializes the unity fog
};

VertexOutput vert (VertexInput v) {
     VertexOutput o = (VertexOutput)0;           
     o.uv0 = v.texcoord0;
     o.uv1 = v.texcoord1;
     o.normalDir = UnityObjectToWorldNormal(v.normal);
     o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
     o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
     o.pos = UnityObjectToClipPos(v.vertex);
     o.posWorld = mul(unity_ObjectToWorld, v.vertex);
     UNITY_TRANSFER_FOG(o,o.pos);
     TRANSFER_VERTEX_TO_FRAGMENT(o)
     return o;
}

//UnityGI GetUnityGI(float3 lightColor, float3 lightDirection, float3 normalDirection,float3 viewDirection, float3 viewReflectDirection, float attenuation, float roughness, float3 worldPos){
 //Unity light Setup ::
  //  UnityLight light;
    //light.color = lightColor;
    //light.dir = lightDirection;
    //light.ndotl = max(0.0h,dot( normalDirection, lightDirection));
    //UnityGIInput d;
    //d.light = light;
    //d.worldPos = worldPos;
    //d.worldViewDir = viewDirection;
    //d.atten = attenuation;
    //d.ambient = 0.0h;
    //d.boxMax[0] = unity_SpecCube0_BoxMax;
    //d.boxMin[0] = unity_SpecCube0_BoxMin;
    //d.probePosition[0] = unity_SpecCube0_ProbePosition;
   // d.probeHDR[0] = unity_SpecCube0_HDR;
    //d.boxMax[1] = unity_SpecCube1_BoxMax;
    //d.boxMin[1] = unity_SpecCube1_BoxMin;
    //d.probePosition[1] = unity_SpecCube1_ProbePosition;
   // d.probeHDR[1] = unity_SpecCube1_HDR;
    //Unity_GlossyEnvironmentData ugls_en_data;
   // ugls_en_data.roughness = roughness;
    //ugls_en_data.reflUVW = viewReflectDirection;
    //UnityGI gi = UnityGlobalIllumination(d, 1.0h, normalDirection, ugls_en_data );
    //return gi;
//}





float4 frag(VertexOutput i) : COLOR {

//Sample
	 fixed4 AlbedoTex = tex2D(_MainTex,i.uv0) * (1 /3.14);
	 //fixed4 BumpMap =  tex2D(_BumpMap,TRANSFORM_TEX(i.uv0,_BumpMap));
    float4 BumpMap = tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap));
    fixed4 MetallicMap = tex2D(_MetallicMap,i.uv0);
//normal direction calculations
	  i.normalDir = normalize(i.normalDir);
	  posWorld = i.posWorld;
     float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
	 float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
     float shiftAmount = dot(i.normalDir, viewDirection);
     float3 normalLocal = NormalIntensity (UnpackNormal (BumpMap));
     float3 normalDirection = normalize(mul( normalLocal, tangentTransform ));
      float3 IBL = texCUBE(_IBL,normalDirection).rgb;
      float3 SPL =  SBL(_SPL,normalDirection, MetallicMap.r);
     //return float4 (normalLocal,1);
	 normalDirection = shiftAmount < 0.0f ? normalDirection + viewDirection * (-shiftAmount + 1e-5f) : normalDirection;

//light calculations
	 fixed3 Light = DirectionalLight(normalDirection)[0];
	 fixed3 Light1 = DirectionalLight(normalDirection)[1];


	 //float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
	 float3 lightDirection = -LightDir0;
	 float3 lightReflectDirection = reflect( -lightDirection, normalDirection );
	 float3 viewReflectDirection = normalize(reflect( -viewDirection, normalDirection ));
     float NdotL = max(0.0, dot( normalDirection, lightDirection ));

     float3 halfDirection = normalize(viewDirection+lightDirection); 
     float NdotH =  max(0.0,dot( normalDirection, halfDirection));
     float NdotV =  max(0.0,dot( normalDirection, viewDirection));
     float VdotH = max(0.0,dot( viewDirection, halfDirection));
     float LdotH =  max(0.0,dot(lightDirection, halfDirection)); 
     float LdotV = max(0.0,dot(lightDirection, viewDirection)); 
     float RdotV = max(0.0, dot( lightReflectDirection, viewDirection ));
     float attenuation = LIGHT_ATTENUATION(i);
     //float3 attenColor = attenuation * _LightColor0.rgb;
     float3 attenColor = LightColor0*LightIntensity0 ;
     
     //get Unity Scene lighting data
   //  UnityGI gi =  GetUnityGI(_LightColor0.rgb, lightDirection, normalDirection, viewDirection, viewReflectDirection, attenuation, 1- _Glossiness , i.posWorld.xyz);
    // float3 indirectDiffuse = gi.indirect.diffuse.rgb ;//+  (IBL * _IBL_Intensity * _AmbientColor * attenColor )
     float3 indirectDiffuse = float3(1,1,1)* _AmbientColor +IBL * _IBL_Intensity;
     float3 indirectSpecular =  SPL ;
	// float3 indirectSpecular = gi.indirect.specular.rgb * SBL_Intensity  ;

  //   return float4 (indirectSpecular,1);
 




	 //diffuse color calculations  //?* gloss
	 float roughness = 1-(_Glossiness * _Glossiness * MetallicMap.a );
	 roughness = roughness * roughness  ;
	 float3 diff =  _Color.rgb * AlbedoTex  ;

     float3 diffuseColor = diff * (1.0 - (_Metallic * MetallicMap.r) ) ;


 	 float f0 = F0(NdotL, NdotV, LdotH, roughness);
	 diffuseColor = diffuseColor * f0 * indirectDiffuse; 


	//Specular calculations


	 //float3 specColor = lerp(_SpecularColor.rgb, _Color.rgb, _Metallic  * MetallicMap.r * 0.5);
	 float3 specColor = lerp(_SpecularColor.rgb, _Color.rgb, _Metallic  * MetallicMap.r * 0.5);
   //  float3 specColor = _Metallic  * MetallicMap.r ;
	 float3 SpecularDistribution = specColor;
	 float GeometricShadow = 1;
	 float3 FresnelFunction = specColor;

	 //Normal Distribution Function/Specular Distribution-----------------------------------------------------	      

           
	#ifdef _NORMALDISTMODEL_BLINNPHONG 
		 SpecularDistribution *=  BlinnPhongNormalDistribution(NdotH, _Glossiness,  max(1,_Glossiness * 40));
	#elif _NORMALDISTMODEL_U3DBLINNPHONG
	     SpecularDistribution *=  BlinnPhongU3D(NdotH, _SpecularColor * _HighLightPower,  exp2( _Glossiness * 10.0 + 1.0 )) * _Glossiness ; 
 	#elif _NORMALDISTMODEL_PHONG
		 SpecularDistribution *=  PhongNormalDistribution(RdotV, _Glossiness, max(1,_Glossiness * 40));
 	#elif _NORMALDISTMODEL_BECKMANN
		 SpecularDistribution *=  BeckmannNormalDistribution(roughness, NdotH);
 	#elif _NORMALDISTMODEL_GAUSSIAN
		 SpecularDistribution *=  GaussianNormalDistribution(roughness, NdotH);
 	#elif _NORMALDISTMODEL_GGX
		 SpecularDistribution *=  GGXNormalDistribution(roughness, NdotH);
 	#elif _NORMALDISTMODEL_TROWBRIDGEREITUE4
		 SpecularDistribution *=  TrowbridgeReitzNormalDistribution(NdotH, roughness);
 	#elif _NORMALDISTMODEL_TROWBRIDGEREITZANISOTROPIC
		 SpecularDistribution *=  TrowbridgeReitzAnisotropicNormalDistribution(_Anisotropic,NdotH, dot(halfDirection, i.tangentDir), dot(halfDirection,  i.bitangentDir));
	#elif _NORMALDISTMODEL_WARD
	 	 SpecularDistribution *=  WardAnisotropicNormalDistribution(_Anisotropic,NdotL, NdotV, NdotH, dot(halfDirection, i.tangentDir), dot(halfDirection,  i.bitangentDir));
	#else
		SpecularDistribution *=  GGXNormalDistribution(roughness, NdotH);
	#endif


	 //Geometric Shadowing term----------------------------------------------------------------------------------
	#ifdef _SMITHGEOSHADOWMODEL_NONE
	 	#ifdef _GEOSHADOWMODEL_ASHIKHMINSHIRLEY
			GeometricShadow *= AshikhminShirleyGeometricShadowingFunction (NdotL, NdotV, LdotH);
	 	#elif _GEOSHADOWMODEL_ASHIKHMINPREMOZE
			GeometricShadow *= AshikhminPremozeGeometricShadowingFunction (NdotL, NdotV);
	 	#elif _GEOSHADOWMODEL_DUER
			GeometricShadow *= DuerGeometricShadowingFunction (lightDirection, viewDirection, normalDirection, NdotL, NdotV);
	 	#elif _GEOSHADOWMODEL_NEUMANN
			GeometricShadow *= NeumannGeometricShadowingFunction (NdotL, NdotV);
	 	#elif _GEOSHADOWMODEL_KELEMAN
			GeometricShadow *= KelemenGeometricShadowingFunction (NdotL, NdotV, LdotH,  VdotH);
	 	#elif _GEOSHADOWMODEL_MODIFIEDKELEMEN
			GeometricShadow *=  ModifiedKelemenGeometricShadowingFunction (NdotV, NdotL, roughness);
	 	#elif _GEOSHADOWMODEL_COOK
			GeometricShadow *= CookTorrenceGeometricShadowingFunction (NdotL, NdotV, VdotH, NdotH);
	 	#elif _GEOSHADOWMODEL_WARD
			GeometricShadow *= WardGeometricShadowingFunction (NdotL, NdotV, VdotH, NdotH);
	 	#elif _GEOSHADOWMODEL_KURT
			GeometricShadow *= KurtGeometricShadowingFunction (NdotL, NdotV, VdotH, roughness);
	 	#else 			
 			GeometricShadow *= ImplicitGeometricShadowingFunction (NdotL, NdotV);
 		#endif
	////SmithModelsBelow
	////Gs = F(NdotL) * F(NdotV);
  	#elif _SMITHGEOSHADOWMODEL_WALTER
		GeometricShadow *= WalterEtAlGeometricShadowingFunction (NdotL, NdotV, roughness);
	#elif _SMITHGEOSHADOWMODEL_BECKMAN
		GeometricShadow *= BeckmanGeometricShadowingFunction (NdotL, NdotV, roughness);
 	#elif _SMITHGEOSHADOWMODEL_GGX
		GeometricShadow *= GGXGeometricShadowingFunction (NdotL, NdotV, roughness);
	#elif _SMITHGEOSHADOWMODEL_SCHLICK
		GeometricShadow *= SchlickGeometricShadowingFunction (NdotL, NdotV, roughness);
 	#elif _SMITHGEOSHADOWMODEL_SCHLICKBECKMAN
		GeometricShadow *= SchlickBeckmanGeometricShadowingFunction (NdotL, NdotV, roughness);
 	#elif _SMITHGEOSHADOWMODEL_SCHLICKGGX
		GeometricShadow *= SchlickGGXGeometricShadowingFunction (NdotL, NdotV, roughness);
	#elif _SMITHGEOSHADOWMODEL_IMPLICIT
		GeometricShadow *= ImplicitGeometricShadowingFunction (NdotL, NdotV);
	#else
		GeometricShadow *= ImplicitGeometricShadowingFunction (NdotL, NdotV);
 	#endif
	 //Fresnel Function-------------------------------------------------------------------------------------------------

	#ifdef _FRESNELMODEL_SCHLICK
		//return float4(1,1,0,1);
		FresnelFunction *=  SchlickFresnelFunction(specColor, LdotH);
	#elif _FRESNELMODEL_SCHLICKIOR
	//	return float4(1,0,1,1);
		FresnelFunction *=  SchlickIORFresnelFunction(_Ior, LdotH);
	#elif _FRESNELMODEL_SPHERICALGAUSSIAN
	//	return float4(0,0,1,1);
		FresnelFunction *= SphericalGaussianFresnelFunction(LdotH, specColor);
	#elif _FRESNELMODEL_SCHICHU3D
		//return float4(1,1,1,1);
		FresnelFunction *= F_Schlick_U3D(NdotV,specColor);
 	#else
		FresnelFunction *=  SchlickIORFresnelFunction(_Ior, LdotH);	

 	#endif


 	#ifdef _ENABLE_NDF_ON
 	 return float4(float3(1,1,1)* SpecularDistribution,1);
    #endif
    #ifdef _ENABLE_G_ON 
 	 return float4(float3(1,1,1) * GeometricShadow,1) ;
    #endif
    #ifdef _ENABLE_F_ON 
 	 return float4(float3(1,1,1)* FresnelFunction,1);
    #endif
	#ifdef _ENABLE_D_ON 
 	 return float4(float3(1,1,1)* diffuseColor,1);
    #endif

	 //PBR
	
	 float3 specularity = (SpecularDistribution * FresnelFunction * GeometricShadow) / (4 * (NdotL * NdotV))  ;

	
     float grazingTerm = saturate(roughness + _Metallic  );
	 float3 unityIndirectSpecularity =  (indirectSpecular  ) * FresnelLerp(specColor,grazingTerm,NdotV) * max(0.15,_Metallic * MetallicMap.r) * (1-roughness*roughness* roughness);
     // return float4 (saturate(specularity)  + unityIndirectSpecularity ,1);


     float3 lightingModel = ( (diffuseColor ) + saturate(specularity)  + unityIndirectSpecularity);

    // specularity = max(specularity,float3(0,0,0)); 
     //specularity = saturate(specularity);
	// float3 lightingModel = (diffuseColor   + (unityIndirectSpecularity *_SPL_Intensity));
    
     lightingModel = lightingModel *  NdotL * attenColor ;// ;
     //lightingModel = lightingModel  *  NdotL * attenColor ;// ;
    
   
     float4 finalDiffuse = float4((lightingModel  )  ,1);//float4(lightingModel * attenColor,1);

     UNITY_APPLY_FOG(i.fogCoord, finalDiffuse);
     return finalDiffuse;
}
ENDCG
}
}
FallBack "Legacy Shaders/Diffuse"
}