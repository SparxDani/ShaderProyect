Shader "Custom/WavingFlagWithLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} // Textura de la bandera
        _Amplitude ("Wave Amplitude", Float) = 0.1 // Amplitud de la onda
        _Frequency ("Wave Frequency", Float) = 1.0 // Frecuencia de la onda
        _Speed ("Wave Speed", Float) = 1.0 // Velocidad del movimiento de la onda
        _Color ("Color", Color) = (1, 1, 1, 1) // Color base de la bandera
        _Gloss ("Gloss", Float) = 0.5 // Para la luz especular
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
            float _Amplitude;
            float _Frequency;
            float _Speed;
            float4 _Color;
            float _Gloss;

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

                // Cálculo de la onda para el movimiento
                float wave = sin(v.vertex.x * _Frequency + _Time.y * _Speed) * _Amplitude;
                v.vertex.y += wave;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Muestra la textura
                fixed4 texColor = tex2D(_MainTex, i.uv) * _Color;

                // Iluminación difusa (Lambert)
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float diff = max(0, dot(i.normalDir, lightDir));

                // Iluminación especular
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);
                float spec = pow(max(0, dot(i.normalDir, halfDir)), _Gloss * 128);

                // Combinar iluminación difusa, especular y textura
                fixed4 finalColor = texColor * diff + texColor * spec;

                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
