Shader "Custom/WavingFlag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} // Propiedad para la textura de la bandera
        _Amplitude ("Wave Amplitude", Float) = 0.1 // Amplitud de la onda (altura del desplazamiento)
        _Frequency ("Wave Frequency", Float) = 1.0 // Frecuencia de la onda (cantidad de ondulaciones)
        _Speed ("Wave Speed", Float) = 1.0 // Velocidad del viento (desplazamiento de la onda)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Uniforms para la textura y la animación
            sampler2D _MainTex;
            float _Amplitude;
            float _Frequency;
            float _Speed;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;

                // Calcular el desplazamiento basado en una onda senoidal
                float wave = sin(v.vertex.x * _Frequency + _Time.y * _Speed) * _Amplitude;

                // Desplazar los vértices en el eje Y para simular el movimiento del viento
                v.vertex.y += wave;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Muestrear la textura usando las coordenadas UV
                fixed4 texColor = tex2D(_MainTex, i.uv);
                return texColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
