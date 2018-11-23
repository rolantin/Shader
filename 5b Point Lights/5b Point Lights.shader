// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shantanu Bhadoria/Basic/5b Point Lights" {

	Properties {

		_Color( "Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )

		_SpecColor( "Specular Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )

		_Shininess( "Shininess", float ) = 10

		_RimColor( "Rim Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )

		_RimPower( "Rim Power", Range( 0.01, 10.0 )) = 3.0

		_lightposition ("_lightposition" , vector ) = (1,1,1,1)

	}

	SubShader {

		Pass {

			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			

			// Pragmas

			#pragma vertex vert

			#pragma fragment frag

			

			// User Defined Variables

			uniform float4 _Color;

			uniform float4 _SpecColor;	

			uniform float _Shininess;

			uniform float4 _RimColor;

			uniform float _RimPower;

			uniform float4 _lightposition;

			

			// Unity Defined Variables		

			uniform float4 _LightColor0;

			// float4x4 _Object2World;

			// float4x4 _World2Object;

			//float4 _WorldSpaceLightPos0;

			

			// Base Input Structs

			struct vertexInput {

				float4 vertex : POSITION;			

				float3 normal : NORMAL;

			};

			struct vertexOutput {

				float4 pos : SV_POSITION;

				float4 posWorld : TEXCOORD0;

				float3 normalDir : TEXCOORD1;

			};

			

			// Vertex Function

			vertexOutput vert(vertexInput v) {

				vertexOutput o;

				

				o.posWorld = mul(unity_ObjectToWorld, v.vertex);

				o.normalDir = normalize( mul( float4( v.normal, 0.0 ), unity_WorldToObject ).xyz );

				

				o.pos = UnityObjectToClipPos(v.vertex);

				return o;



			}

			 

			// Fragment Function

			float4 frag(vertexOutput i) : COLOR {

							

				float3 normalDirection = i.normalDir;

				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );

				float3 lightDirection; // = normalize( _WorldSpaceLightPos0.xyz );

				float atten; // = 1.0; 

				


					float3 fragmentToLightSource = _lightposition.xyz - i.posWorld.xyz; 

					float distance = length( fragmentToLightSource );

					atten = 1.0/distance;

					lightDirection = normalize( fragmentToLightSource );

				

				

				// Lighting

				float3 diffuseReflection = atten * float3(1,1,1) * saturate( dot( normalDirection, lightDirection ) );

				//float3 specularReflection = atten * _SpecColor.rgb * saturate( dot( normalDirection, lightDirection ) ) * pow( saturate( dot( reflect( -lightDirection, normalDirection ), viewDirection ) ), _Shininess );

				

				// Rim Lighting

			

			
				

				float3 lightFinal =  diffuseReflection ;

				

				return float4( lightFinal * _Color.rgb, 1.0 );

			}

			

			ENDCG	

		}

	} 

	//FallBack "Specular"

}