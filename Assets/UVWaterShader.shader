Shader "Unlit/UVWaterShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HorizontalSpeed ("HorizontalSpeed", Range(1, 100)) = 10
        _VerticalSpeed ("VerticalSpeed", Range(1, 100)) = 10
        _XShift("Xuv Shift", Range(-1.0, 1.0)) = 0.1
        _YShift("Yuv Shift", Range(-1.0, 1.0)) = 0.1
        _WaveParameter("Wave Parameter", Range(-1.0, 1.0)) = 0.1
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _HorizontalSpeed;
            float _VerticalSpeed;
            float _XShift;
            float _YShift;
            float _WaveParameter;

            v2f vert (appdata v)
            {
                v2f o;
                float delta = (_SinTime.w + 1.0) / 2.0;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex.y += sin(v.vertex.x + _Time.y *10) * _WaveParameter;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                _XShift = _XShift * _HorizontalSpeed;
                _YShift = _YShift * _VerticalSpeed;
                i.uv.x = i.uv.x +_XShift * _Time;
                i.uv.y = i.uv.y +_YShift * _Time;


                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
