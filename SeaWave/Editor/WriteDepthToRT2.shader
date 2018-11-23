Shader "Rolan/WriteDepthToRT2"
{
	 
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 100
		//Cull Off
		Blend SrcAlpha OneMinusSrcAlpha

		GrabPass{}
		zwrite off

		Pass
		{   
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog		
	
 			#include "../../CGIncludes/UnityCG.cginc"
			#pragma target 3.0


	 
	 		sampler2D _CameraDepthTexture;

			struct VertexInput  
			{			 
			    float4 vertex: POSITION;
                float3 normal: NORMAL;
				float4 tangent : TANGENT;
                float2 texcoord0: TEXCOORD0;   
			};

			struct  VertexOutput
			{
			    float4 pos: SV_POSITION;
                float4 proj : TEXCOORD0; 

	  
				  
			};


			VertexOutput vert(VertexInput v){			  
			VertexOutput o = (VertexOutput) 0;
 
       
 
            o.pos = UnityObjectToClipPos(v.vertex);
            o.proj = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
         
			fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
			fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
			fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
			fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;

	 

            //COMPUTE_EYEDEPTH(o.proj.z);

			 return o;
			}

			struct PixelOutput {
            float4 col0 : COLOR0;
            float4 col1 : COLOR1;
       		 };

			 PixelOutput frag (VertexOutput i):COLOR{
			 float4 proj = i.proj;
			 float m_depth = tex2D(_CameraDepthTexture, (i.proj)).r;
			 //float m_depth =  tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.proj)).r;
			 float deltaDepth = m_depth ;
			 //float deltaDepth = m_depth - proj.z  ;
			 //float deltaDepth =  proj.z  ;
 
			 PixelOutput o;
			 o.col0 = float4(1.0f, 0.0f, 0.0f, 1.0f); 
			 o.col1 =  float4(deltaDepth, 0.0f, 0.0f, 1.0f); // float4(deltaDepth,deltaDepth,deltaDepth,1);;
			 return o;
 
				 
				 //return specLight * _Linear + float4(albedo * _AddAlbedo, 0);

			}

		
			ENDCG
		}


	}
//	FallBack "Diffuse"
}
