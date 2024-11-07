Shader "Custom/FullLightingShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} // Textura del objeto
        _Color ("Color", Color) = (1, 1, 1, 1) // Color base del objeto
        _Gloss ("Gloss", Float) = 0.5 // Control de brillo especular
        _AmbientColor ("Ambient Light Color", Color) = (0.2, 0.2, 0.2, 1) // Color de luz ambiental
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 300

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Uniforms
            sampler2D _MainTex;
            float4 _Color;
            float _Gloss;
            float4 _AmbientColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Muestra la textura y aplica el color base
                fixed4 texColor = tex2D(_MainTex, i.uv) * _Color;

                // Luz ambiental
                fixed4 ambient = _AmbientColor * texColor;

                // Iluminación difusa (Lambert)
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float diff = max(0, dot(i.normalDir, lightDir));
                fixed4 diffuse = diff * texColor;

                // Iluminación especular (Blinn-Phong)
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);
                float spec = pow(max(0, dot(i.normalDir, halfDir)), _Gloss * 128);
                fixed4 specular = spec * texColor;

                // Combinar luz ambiental, difusa y especular
                fixed4 finalColor = ambient + diffuse + specular;

                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
