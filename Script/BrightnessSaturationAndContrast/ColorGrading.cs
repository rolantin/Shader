using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.PostProcessing;

//using Sirenix.OdinInspector;

[Serializable]
public  class ColorGrading : PostEffectBase
{
    ColorGradingModel model;
   // private RenderTexture bakedLut;
   // public Settings settings;


    public enum Tonemapper
    {
        None,

        /// <summary>
        /// ACES Filmic reference tonemapper.
        /// </summary>
        ACES,

        /// <summary>
        /// Neutral tonemapper (based off John Hable's & Jim Hejl's work).
        /// </summary>
        Neutral
    }

    [Serializable]
    public struct TonemappingSettings
    {
        [Tooltip("Tonemapping algorithm to use at the end of the color grading process. Use \"Neutral\" if you need a customizable tonemapper or \"Filmic\" to give a standard filmic look to your scenes.")]
        public Tonemapper tonemapper;

        // Neutral settings
        [Range(-0.1f, 0.1f)]
        public float neutralBlackIn;

        [Range(1f, 20f)]
        public float neutralWhiteIn;

        [Range(-0.09f, 0.1f)]
        public float neutralBlackOut;

        [Range(1f, 19f)]
        public float neutralWhiteOut;

        [Range(0.1f, 20f)]
        public float neutralWhiteLevel;

        [Range(1f, 10f)]
        public float neutralWhiteClip;

        public static TonemappingSettings defaultSettings
        {
            get
            {
                return new TonemappingSettings
                {
                    tonemapper = Tonemapper.Neutral,

                    neutralBlackIn = 0.02f,
                    neutralWhiteIn = 10f,
                    neutralBlackOut = 0f,
                    neutralWhiteOut = 10f,
                    neutralWhiteLevel = 5.3f,
                    neutralWhiteClip = 10f
                };
            }
        }
    }

    [Serializable]
    public struct BasicSettings
    {
        [Tooltip("Adjusts the overall exposure of the scene in EV units. This is applied after HDR effect and right before tonemapping so it won't affect previous effects in the chain.")]
        public float postExposure;

        [Range(-100f, 100f), Tooltip("Sets the white balance to a custom color temperature.")]
        public float temperature;

        [Range(-100f, 100f), Tooltip("Sets the white balance to compensate for a green or magenta tint.")]
        public float tint;

        [Range(-180f, 180f), Tooltip("Shift the hue of all colors.")]
        public float hueShift;

        [Range(0f, 2f), Tooltip("Pushes the intensity of all colors.")]
        public float saturation;

        [Range(0f, 2f), Tooltip("Expands or shrinks the overall range of tonal values.")]
        public float contrast;

        public static BasicSettings defaultSettings
        {
            get
            {
                return new BasicSettings
                {
                    postExposure = 0f,

                    temperature = 0f,
                    tint = 0f,

                    hueShift = 0f,
                    saturation = 1f,
                    contrast = 1f,
                };
            }
        }
    }

    [Serializable]
    public struct ChannelMixerSettings
    {
        public Vector3 red;
        public Vector3 green;
        public Vector3 blue;

        [HideInInspector]
        public int currentEditingChannel; // Used only in the editor

        public static ChannelMixerSettings defaultSettings
        {
            get
            {
                return new ChannelMixerSettings
                {
                    red = new Vector3(1f, 0f, 0f),
                    green = new Vector3(0f, 1f, 0f),
                    blue = new Vector3(0f, 0f, 1f),
                    currentEditingChannel = 0
                };
            }
        }
    }

    [Serializable]
    public struct LogWheelsSettings
    {
        [UnityEngine.PostProcessing.Trackball("GetSlopeValue")]
        public Color slope;

        [UnityEngine.PostProcessing.Trackball("GetPowerValue")]
        public Color power;

        [UnityEngine.PostProcessing.Trackball("GetOffsetValue")]
        public Color offset;

        public static LogWheelsSettings defaultSettings
        {
            get
            {
                return new LogWheelsSettings
                {
                    slope = Color.clear,
                    power = Color.clear,
                    offset = Color.clear
                };
            }
        }
    }

    [Serializable]
    public struct LinearWheelsSettings
    {
        [UnityEngine.PostProcessing.Trackball("GetLiftValue")]
        public Color lift;

        [UnityEngine.PostProcessing.Trackball("GetGammaValue")]
        public Color gamma;

        [UnityEngine.PostProcessing.Trackball("GetGainValue")]
        public Color gain;

        public static LinearWheelsSettings defaultSettings
        {
            get
            {
                return new LinearWheelsSettings
                {
                    lift = Color.clear,
                    gamma = Color.clear,
                    gain = Color.clear
                };
            }
        }
    }

    public enum ColorWheelMode
    {
        Linear,
        Log
    }

    

    [Serializable]
    public struct ColorWheelsSettings
    {
        public ColorWheelMode mode;

        [UnityEngine.PostProcessing.TrackballGroup]
        public LogWheelsSettings log;

        [UnityEngine.PostProcessing.TrackballGroup]
        public LinearWheelsSettings linear;

        public static ColorWheelsSettings defaultSettings
        {
            get
            {
                return new ColorWheelsSettings
                {
                    mode = ColorWheelMode.Log,
                    log = LogWheelsSettings.defaultSettings,
                    linear = LinearWheelsSettings.defaultSettings
                };
            }
        }
    }

    [Serializable]
    public struct CurvesSettings
    {
        public ColorGradingCurve master;
        public ColorGradingCurve red;
        public ColorGradingCurve green;
        public ColorGradingCurve blue;
        public ColorGradingCurve hueVShue;
        public ColorGradingCurve hueVSsat;
        public ColorGradingCurve satVSsat;
        public ColorGradingCurve lumVSsat;

        // Used only in the editor
        [HideInInspector] public int e_CurrentEditingCurve;
        [HideInInspector] public bool e_CurveY;
        [HideInInspector] public bool e_CurveR;
        [HideInInspector] public bool e_CurveG;
        [HideInInspector] public bool e_CurveB;

        public static CurvesSettings defaultSettings
        {
            get
            {
                return new CurvesSettings
                {
                    master = new ColorGradingCurve(new AnimationCurve(new Keyframe(0f, 0f, 1f, 1f), new Keyframe(1f, 1f, 1f, 1f)), 0f, false, new Vector2(0f, 1f)),
                    red = new ColorGradingCurve(new AnimationCurve(new Keyframe(0f, 0f, 1f, 1f), new Keyframe(1f, 1f, 1f, 1f)), 0f, false, new Vector2(0f, 1f)),
                    green = new ColorGradingCurve(new AnimationCurve(new Keyframe(0f, 0f, 1f, 1f), new Keyframe(1f, 1f, 1f, 1f)), 0f, false, new Vector2(0f, 1f)),
                    blue = new ColorGradingCurve(new AnimationCurve(new Keyframe(0f, 0f, 1f, 1f), new Keyframe(1f, 1f, 1f, 1f)), 0f, false, new Vector2(0f, 1f)),

                    hueVShue = new ColorGradingCurve(new AnimationCurve(), 0.5f, true, new Vector2(0f, 1f)),
                    hueVSsat = new ColorGradingCurve(new AnimationCurve(), 0.5f, true, new Vector2(0f, 1f)),
                    satVSsat = new ColorGradingCurve(new AnimationCurve(), 0.5f, false, new Vector2(0f, 1f)),
                    lumVSsat = new ColorGradingCurve(new AnimationCurve(), 0.5f, false, new Vector2(0f, 1f)),

                    e_CurrentEditingCurve = 0,
                    e_CurveY = true,
                    e_CurveR = false,
                    e_CurveG = false,
                    e_CurveB = false
                };
            }
        }
    }


    //面板
    [Serializable]
    public struct Settings
    {
        public TonemappingSettings tonemapping;
        public BasicSettings basic;
        public ChannelMixerSettings channelMixer;
        public ColorWheelsSettings colorWheels;
        public CurvesSettings curves;

        public static Settings defaultSettings
        {
            get
            {
                return new Settings
                {
                    tonemapping = TonemappingSettings.defaultSettings,
                    basic = BasicSettings.defaultSettings,
                    channelMixer = ChannelMixerSettings.defaultSettings,
                    colorWheels = ColorWheelsSettings.defaultSettings,
                    curves = CurvesSettings.defaultSettings
                };
            }
        }
    }

    [SerializeField]
    Settings m_Settings = Settings.defaultSettings;
    public Settings settings
    {
        get { return m_Settings; }
        set
        {
            m_Settings = value;
            OnValidate();
        }
    }

    public bool isDirty { get; internal set; }
    public RenderTexture bakedLut { get; internal set; }

    public  void Reset()
    {
        m_Settings = Settings.defaultSettings;
        OnValidate();
    }

    public  void OnValidate()
    {
        isDirty = true;
    }




    private Material lutMaterial;
    // BrightnessSaturationAndContrast bsc = new BrightnessSaturationAndContrast();
    private Shader ColorGradingShader;
    private Material ColorGradingMaterial;
    Texture2D m_GradingCurves;

    static class Uniforms
    {
        internal static readonly int _LutParams = Shader.PropertyToID("_LutParams");
        internal static readonly int _NeutralTonemapperParams1 = Shader.PropertyToID("_NeutralTonemapperParams1");
        internal static readonly int _NeutralTonemapperParams2 = Shader.PropertyToID("_NeutralTonemapperParams2");
        internal static readonly int _HueShift = Shader.PropertyToID("_HueShift");
        internal static readonly int _Saturation = Shader.PropertyToID("_Saturation");
        internal static readonly int _Contrast = Shader.PropertyToID("_Contrast");
        internal static readonly int _Balance = Shader.PropertyToID("_Balance");
        internal static readonly int _Lift = Shader.PropertyToID("_Lift");
        internal static readonly int _InvGamma = Shader.PropertyToID("_InvGamma");
        internal static readonly int _Gain = Shader.PropertyToID("_Gain");
        internal static readonly int _Slope = Shader.PropertyToID("_Slope");
        internal static readonly int _Power = Shader.PropertyToID("_Power");
        internal static readonly int _Offset = Shader.PropertyToID("_Offset");
        internal static readonly int _ChannelMixerRed = Shader.PropertyToID("_ChannelMixerRed");
        internal static readonly int _ChannelMixerGreen = Shader.PropertyToID("_ChannelMixerGreen");
        internal static readonly int _ChannelMixerBlue = Shader.PropertyToID("_ChannelMixerBlue");
        internal static readonly int _Curves = Shader.PropertyToID("_Curves");
        internal static readonly int _LogLut = Shader.PropertyToID("_LogLut");
        internal static readonly int _LogLut_Params = Shader.PropertyToID("_LogLut_Params");
        internal static readonly int _ExposureEV = Shader.PropertyToID("_ExposureEV");
    }

    //像素
    Color[] m_pixels = new Color[k_CurvePrecision * 2];
    //图片格式
    TextureFormat GetCurveFormat(){
            if (SystemInfo.SupportsTextureFormat(TextureFormat.RGBAHalf))
            return TextureFormat.RGBAHalf;
            return TextureFormat.RGBA32;
    }

    float StandardIlluminantY(float x){
        return 2.87f * x - 3f * x * x - 0.27509507f;
    }

    Vector3 CIExyToLMS(float x, float y)
    {
        float Y = 1f;
        float X = Y * x / y;
        float Z = Y * (1f - x - y) / y;

        float L = 0.7328f * X + 0.4296f * Y - 0.1624f * Z;
        float M = -0.7036f * X + 1.6975f * Y + 0.0061f * Z;
        float S = 0.0030f * X + 0.0136f * Y + 0.9834f * Z;

        return new Vector3(L, M, S);
    }
    Vector3 CalculateColorBalance(float temperature, float tint)
    {
        // Range ~[-1.8;1.8] ; using higher ranges is unsafe
        float t1 = temperature / 55f;
        float t2 = tint / 55f;

        // Get the CIE xy chromaticity of the reference white point.
        // Note: 0.31271 = x value on the D65 white point
        float x = 0.31271f - t1 * (t1 < 0f ? 0.1f : 0.05f);
        float y = StandardIlluminantY(x) + t2 * 0.05f;

        // Calculate the coefficients in the LMS space.
        var w1 = new Vector3(0.949237f, 1.03542f, 1.08728f); // D65 white point
        var w2 = CIExyToLMS(x, y);
        return new Vector3(w1.x / w2.x, w1.y / w2.y, w1.z / w2.z);
    }
    static Vector3 ClampVector(Vector3 v, float min, float max)
    {
        return new Vector3(
            Mathf.Clamp(v.x, min, max),
            Mathf.Clamp(v.y, min, max),
            Mathf.Clamp(v.z, min, max)
            );
    }
    static Color NormalizeColor(Color c)
    {
        float sum = (c.r + c.g + c.b) / 3f;

        if (Mathf.Approximately(sum, 0f))
            return new Color(1f, 1f, 1f, c.a);

        return new Color
        {
            r = c.r / sum,
            g = c.g / sum,
            b = c.b / sum,
            a = c.a
        };
    }
    public static Vector3 GetLiftValue(Color lift)
    {
        const float kLiftScale = 0.1f;

        var nLift = NormalizeColor(lift);
        float avgLift = (nLift.r + nLift.g + nLift.b) / 3f;

        // Getting some artifacts when going into the negatives using a very low offset (lift.a) with non ACES-tonemapping
        float liftR = (nLift.r - avgLift) * kLiftScale + lift.a;
        float liftG = (nLift.g - avgLift) * kLiftScale + lift.a;
        float liftB = (nLift.b - avgLift) * kLiftScale + lift.a;

        return ClampVector(new Vector3(liftR, liftG, liftB), -1f, 1f);
    }
    public static Vector3 GetGammaValue(Color gamma)
    {
        const float kGammaScale = 0.5f;
        const float kMinGamma = 0.01f;

        var nGamma = NormalizeColor(gamma);
        float avgGamma = (nGamma.r + nGamma.g + nGamma.b) / 3f;

        gamma.a *= gamma.a < 0f ? 0.8f : 5f;
        float gammaR = Mathf.Pow(2f, (nGamma.r - avgGamma) * kGammaScale) + gamma.a;
        float gammaG = Mathf.Pow(2f, (nGamma.g - avgGamma) * kGammaScale) + gamma.a;
        float gammaB = Mathf.Pow(2f, (nGamma.b - avgGamma) * kGammaScale) + gamma.a;

        float invGammaR = 1f / Mathf.Max(kMinGamma, gammaR);
        float invGammaG = 1f / Mathf.Max(kMinGamma, gammaG);
        float invGammaB = 1f / Mathf.Max(kMinGamma, gammaB);

        return ClampVector(new Vector3(invGammaR, invGammaG, invGammaB), 0f, 5f);
    }
    public static Vector3 GetGainValue(Color gain){
        const float kGainScale = 0.5f;
        var nGain = NormalizeColor(gain);
        float avgGain = (nGain.r + nGain.g + nGain.b) / 3f;
        gain.a *= gain.a > 0f ? 3f : 1f;
        float gainR = Mathf.Pow(2f, (nGain.r - avgGain) * kGainScale) + gain.a;
        float gainG = Mathf.Pow(2f, (nGain.g - avgGain) * kGainScale) + gain.a;
        float gainB = Mathf.Pow(2f, (nGain.b - avgGain) * kGainScale) + gain.a;
        return ClampVector(new Vector3(gainR, gainG, gainB), 0f, 4f);
    }
    public static void CalculateLiftGammaGain(Color lift, Color gamma, Color gain, out Vector3 outLift, out Vector3 outGamma, out Vector3 outGain)
    {
        outLift = GetLiftValue(lift);
        outGamma = GetGammaValue(gamma);
        outGain = GetGainValue(gain);
    }
    public static Vector3 GetSlopeValue(Color slope)
    {
        const float kSlopeScale = 0.1f;

        var nSlope = NormalizeColor(slope);
        float avgSlope = (nSlope.r + nSlope.g + nSlope.b) / 3f;

        slope.a *= 0.5f;
        float slopeR = (nSlope.r - avgSlope) * kSlopeScale + slope.a + 1f;
        float slopeG = (nSlope.g - avgSlope) * kSlopeScale + slope.a + 1f;
        float slopeB = (nSlope.b - avgSlope) * kSlopeScale + slope.a + 1f;

        return ClampVector(new Vector3(slopeR, slopeG, slopeB), 0f, 2f);
    }
    public static Vector3 GetPowerValue(Color power)
    {
        const float kPowerScale = 0.1f;
        const float minPower = 0.01f;

        var nPower = NormalizeColor(power);
        float avgPower = (nPower.r + nPower.g + nPower.b) / 3f;

        power.a *= 0.5f;
        float powerR = (nPower.r - avgPower) * kPowerScale + power.a + 1f;
        float powerG = (nPower.g - avgPower) * kPowerScale + power.a + 1f;
        float powerB = (nPower.b - avgPower) * kPowerScale + power.a + 1f;

        float invPowerR = 1f / Mathf.Max(minPower, powerR);
        float invPowerG = 1f / Mathf.Max(minPower, powerG);
        float invPowerB = 1f / Mathf.Max(minPower, powerB);

        return ClampVector(new Vector3(invPowerR, invPowerG, invPowerB), 0.5f, 2.5f);
    }
    public static Vector3 GetOffsetValue(Color offset)
    {
        const float kOffsetScale = 0.05f;

        var nOffset = NormalizeColor(offset);
        float avgOffset = (nOffset.r + nOffset.g + nOffset.b) / 3f;

        offset.a *= 0.5f;
        float offsetR = (nOffset.r - avgOffset) * kOffsetScale + offset.a;
        float offsetG = (nOffset.g - avgOffset) * kOffsetScale + offset.a;
        float offsetB = (nOffset.b - avgOffset) * kOffsetScale + offset.a;

        return ClampVector(new Vector3(offsetR, offsetG, offsetB), -0.8f, 0.8f);
    }
    public static void CalculateSlopePowerOffset(Color slope, Color power, Color offset, out Vector3 outSlope, out Vector3 outPower, out Vector3 outOffset)
    {
        outSlope = GetSlopeValue(slope);
        outPower = GetPowerValue(power);
        outOffset = GetOffsetValue(offset);
    }

    Texture2D GetCurveTexture()
    {
        if (m_GradingCurves == null)
        {
            //k_CurvePrecision //Properties
            m_GradingCurves = new Texture2D(k_CurvePrecision, 2, GetCurveFormat(), false, true){
                name = "Internal Curves Texture",
                hideFlags = HideFlags.DontSave,
                anisoLevel = 0,
                wrapMode = TextureWrapMode.Clamp,
                filterMode = FilterMode.Bilinear
            };
        }
       var curves = settings.curves;
        curves.hueVShue.Cache();
        curves.hueVSsat.Cache();
        //储存颜色
        for (int i = 0; i < k_CurvePrecision; i++)
        {
            float t = i * k_CurveStep;
            // HSL
            float x = curves.hueVShue.Evaluate(t);
            float y = curves.hueVSsat.Evaluate(t);
            float z = curves.satVSsat.Evaluate(t);
            float w = curves.lumVSsat.Evaluate(t);
            m_pixels[i] = new Color(x, y, z, w);

            // YRGB
            float m = curves.master.Evaluate(t);
            float r = curves.red.Evaluate(t);
            float g = curves.green.Evaluate(t);
            float b = curves.blue.Evaluate(t);
            m_pixels[i + k_CurvePrecision] = new Color(r, g, b, m);
        }

        m_GradingCurves.SetPixels(m_pixels);
        m_GradingCurves.Apply(false, false);
        return m_GradingCurves;
    }

    // public T model { get; internal set; }
    const int k_InternalLogLutSize = 32;
    const int k_CurvePrecision = 128;
    const float k_CurveStep = 1f / k_CurvePrecision;
    bool IsLogLutValid(RenderTexture lut)
    {
        return lut != null && lut.IsCreated() && lut.height == k_InternalLogLutSize;
    }

    RenderTextureFormat GetLutFormat() {
        if (SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBHalf))
            return RenderTextureFormat.ARGBHalf;
        return RenderTextureFormat.ARGB32;
    }

    void GenerateLut()
    {
        if (!IsLogLutValid(bakedLut))
        {
            UnityEngine.Rolan.Graphicsutils.Destroy(bakedLut);

            bakedLut = new RenderTexture(k_InternalLogLutSize * k_InternalLogLutSize, k_InternalLogLutSize, 0, GetLutFormat())
            {
                name = "Color Grading Log LUT",
                hideFlags = HideFlags.DontSave,
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp,
                anisoLevel = 0
            };
        }


        // var lutMaterial = context.materialFactory.Get("Hidden/Post FX/Lut Generator");
        //  var lutMaterial = mat;
        lutMaterial = new Material(Shader.Find("Hidden/Post FX/Lut Generator"));
        lutMaterial.SetVector(Uniforms._LutParams, new Vector4(
                k_InternalLogLutSize,
                0.5f / (k_InternalLogLutSize * k_InternalLogLutSize),
                0.5f / k_InternalLogLutSize,
                k_InternalLogLutSize / (k_InternalLogLutSize - 1f))
            );

        // Tonemapping
        lutMaterial.shaderKeywords = null;

        var tonemapping = settings.tonemapping;
        switch (tonemapping.tonemapper)
        {
            case Tonemapper.Neutral:
                {
                    lutMaterial.EnableKeyword("TONEMAPPING_NEUTRAL");
                    const float scaleFactor = 20f;
                    const float scaleFactorHalf = scaleFactor * 0.5f;

                    float inBlack = tonemapping.neutralBlackIn * scaleFactor + 1f;
                    float outBlack = tonemapping.neutralBlackOut * scaleFactorHalf + 1f;
                    float inWhite = tonemapping.neutralWhiteIn / scaleFactor;
                    float outWhite = 1f - tonemapping.neutralWhiteOut / scaleFactor;
                    float blackRatio = inBlack / outBlack;
                    float whiteRatio = inWhite / outWhite;


                    const float a = 0.2f;
                    float b = Mathf.Max(0f, Mathf.LerpUnclamped(0.57f, 0.37f, blackRatio));
                    float c = Mathf.LerpUnclamped(0.01f, 0.24f, whiteRatio);
                    float d = Mathf.Max(0f, Mathf.LerpUnclamped(0.02f, 0.20f, blackRatio));
                    const float e = 0.02f;
                    const float f = 0.30f;

                    lutMaterial.SetVector(Uniforms._NeutralTonemapperParams1, new Vector4(a, b, c, d));
                    lutMaterial.SetVector(Uniforms._NeutralTonemapperParams2, new Vector4(e, f, tonemapping.neutralWhiteLevel, tonemapping.neutralWhiteClip / scaleFactorHalf));
                    break;
                }

            case Tonemapper.ACES:
                {
                    lutMaterial.EnableKeyword("TONEMAPPING_FILMIC");
                    break;
                }
        }

        // Color balance & basic grading settings
        lutMaterial.SetFloat(Uniforms._HueShift, settings.basic.hueShift / 360f);
        lutMaterial.SetFloat(Uniforms._Saturation, settings.basic.saturation);
        lutMaterial.SetFloat(Uniforms._Contrast, settings.basic.contrast);
        lutMaterial.SetVector(Uniforms._Balance, CalculateColorBalance(settings.basic.temperature, settings.basic.tint));

        // Lift / Gamma / Gain
        Vector3 lift, gamma, gain;
        CalculateLiftGammaGain(
            settings.colorWheels.linear.lift,
            settings.colorWheels.linear.gamma,
            settings.colorWheels.linear.gain,
            out lift, out gamma, out gain
            );

        lutMaterial.SetVector(Uniforms._Lift, lift);
        lutMaterial.SetVector(Uniforms._InvGamma, gamma);
        lutMaterial.SetVector(Uniforms._Gain, gain);

        // Slope / Power / Offset
        Vector3 slope, power, offset;
        CalculateSlopePowerOffset(
            settings.colorWheels.log.slope,
            settings.colorWheels.log.power,
            settings.colorWheels.log.offset,
            out slope, out power, out offset
            );

        lutMaterial.SetVector(Uniforms._Slope, slope);
        lutMaterial.SetVector(Uniforms._Power, power);
        lutMaterial.SetVector(Uniforms._Offset, offset);

        // Channel mixer
        lutMaterial.SetVector(Uniforms._ChannelMixerRed, settings.channelMixer.red);
        lutMaterial.SetVector(Uniforms._ChannelMixerGreen, settings.channelMixer.green);
        lutMaterial.SetVector(Uniforms._ChannelMixerBlue, settings.channelMixer.blue);

        // Selective grading & YRGB curves
        lutMaterial.SetTexture(Uniforms._Curves, GetCurveTexture());

        // Generate the lut
        Graphics.Blit(null, bakedLut, lutMaterial, 0);

    }


    //keycode
     void Update()
    {
        if (Input.GetKey(KeyCode.F1))
        {
            SaveRenderToPng(bakedLut, "F://save.png");
        }
    }


    static public void SaveRenderToPng(RenderTexture renderT, string path)
    {
        int width = renderT.width;
        int height = renderT.height;
        Texture2D tex2d = new Texture2D(width, height, TextureFormat.ARGB32, false);
        RenderTexture.active = renderT;
        tex2d.ReadPixels(new Rect(0, 0, width, height), 0, 0);
        tex2d.Apply();
        byte[] b = tex2d.EncodeToPNG();
        System.IO.File.WriteAllBytes(path, b);
        GameObject.DestroyImmediate(tex2d);
    }


    public Material material {
        get {
            ColorGradingShader = Shader.Find("RolanImageEffect/BrightnessSaturationAndContrast");
            ColorGradingMaterial = CheckShaderAndCreateMaterial(ColorGradingShader, ColorGradingMaterial);
            return ColorGradingMaterial;
        }
    }
   // [Range(0.0f, 3.0f)]
   public  float brightness = 1.0f;

  //  [Range(0.0f, 3.0f)]
    public float saturation = 1.0f;

   //[ Range(0.0f, 3.0f)]
    public float contrast = 1.0f;
    //定义OnRenderImage函数来进特效处理
    //当OnRenderImage函数被调用的时候，他会检查材质球是否可用。如果可用，就把参数传递给材质，
    //再调用Graphics.Blit进行处理；否则，直接把原图像显示到屏幕上，不做任何处理。

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {

        GenerateLut();

        lutMaterial.SetTexture(Uniforms._LogLut, bakedLut);

        Graphics.Blit(src, dest, lutMaterial);

        //// Debug.Log(" bsc.brightness = " + bsc.brightness);
        //if (material != null)
        //{
        //    material.SetFloat("_Brightness", brightness);
        //    material.SetFloat("_Saturation", saturation);
        //    material.SetFloat("_Contrast", contrast);

        //    Graphics.Blit(src, dest, lutMaterial);
        //}
        //else {
        //    //不做处理
        //    Graphics.Blit(src, dest);
        //}
    }


}

//知识点：
//public static void Blit(Texture source, RenderTexture dest);
//public static void Blit(Texture source, RenderTexture dest, Material mat, int pass = -1);
//public static void Blit(Texture source, Material mat, int pass = -1);

//src： 原纹理 ，当前屏幕的文理，也是传给材质球的_MainTex的图

//dest :目标文理，经过shader返回的图 。如果他的值为null就会直接将结果显示在屏幕上

//met：材质球

//pass：默认为-1，表示将依次调用shader内的pass。否则只会调用给定索引的Pass

//lerp函数（a，b，w）：很多人都觉得w为0到1范围，然后返回值是a到b之间 其实并不仅仅是这些

//    float3 lerp(float3 a, float3 b, float w)
//{
//    return a + w * (b - a);
//}