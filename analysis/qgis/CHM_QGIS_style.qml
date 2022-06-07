<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis minScale="1e+08" maxScale="0" hasScaleBasedVisibilityFlag="0" styleCategories="AllStyleCategories" version="3.18.3-Zürich">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>0</Searchable>
    <Private>0</Private>
  </flags>
  <temporal mode="0" enabled="0" fetchMode="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <customproperties>
    <property value="false" key="WMSBackgroundLayer"/>
    <property value="false" key="WMSPublishDataSourceUrl"/>
    <property value="0" key="embeddedWidgets/count"/>
  </customproperties>
  <pipe>
    <provider>
      <resampling enabled="false" zoomedInResamplingMethod="nearestNeighbour" zoomedOutResamplingMethod="nearestNeighbour" maxOversampling="2"/>
    </provider>
    <rasterrenderer opacity="1" nodataColor="" classificationMin="0.5" band="1" alphaBand="-1" type="singlebandpseudocolor" classificationMax="inf">
      <rasterTransparency/>
      <minMaxOrigin>
        <limits>None</limits>
        <extent>WholeRaster</extent>
        <statAccuracy>Estimated</statAccuracy>
        <cumulativeCutLower>0.02</cumulativeCutLower>
        <cumulativeCutUpper>0.98</cumulativeCutUpper>
        <stdDevFactor>2</stdDevFactor>
      </minMaxOrigin>
      <rastershader>
        <colorrampshader maximumValue="inf" labelPrecision="6" clip="0" classificationMode="1" colorRampType="DISCRETE" minimumValue="0.5">
          <colorramp name="[source]" type="gradient">
            <Option type="Map">
              <Option value="247,252,245,255" name="color1" type="QString"/>
              <Option value="0,68,27,255" name="color2" type="QString"/>
              <Option value="0" name="discrete" type="QString"/>
              <Option value="gradient" name="rampType" type="QString"/>
              <Option value="0.13;229,245,224,255:0.26;199,233,192,255:0.39;161,217,155,255:0.52;116,196,118,255:0.65;65,171,93,255:0.78;35,139,69,255:0.9;0,109,44,255" name="stops" type="QString"/>
            </Option>
            <prop v="247,252,245,255" k="color1"/>
            <prop v="0,68,27,255" k="color2"/>
            <prop v="0" k="discrete"/>
            <prop v="gradient" k="rampType"/>
            <prop v="0.13;229,245,224,255:0.26;199,233,192,255:0.39;161,217,155,255:0.52;116,196,118,255:0.65;65,171,93,255:0.78;35,139,69,255:0.9;0,109,44,255" k="stops"/>
          </colorramp>
          <item value="0.5" color="#000797" alpha="255" label="&lt;= 0.5"/>
          <item value="1" color="#ffffff" alpha="255" label="0.5 - 1"/>
          <item value="2" color="#f3fff4" alpha="255" label="1 - 2"/>
          <item value="3" color="#ffffff" alpha="255" label="2 - 3"/>
          <item value="4" color="#ffff0e" alpha="255" label="3 - 4"/>
          <item value="5" color="#ff0004" alpha="255" label="4 - 5"/>
          <item value="6" color="#73ff7c" alpha="255" label="5 - 6"/>
          <item value="7" color="#00fa14" alpha="255" label="6 - 7"/>
          <item value="8" color="#00f014" alpha="255" label="7 - 8"/>
          <item value="9" color="#00e817" alpha="255" label="8 - 9"/>
          <item value="10" color="#00da19" alpha="255" label="9 - 10"/>
          <item value="11" color="#00cd1b" alpha="255" label="10 - 11"/>
          <item value="12" color="#00c21d" alpha="255" label="11 - 12"/>
          <item value="13" color="#00b91e" alpha="255" label="12 - 13"/>
          <item value="14" color="#00b521" alpha="255" label="13 - 14"/>
          <item value="15" color="#00b023" alpha="255" label="14 - 15"/>
          <item value="16" color="#00aa24" alpha="255" label="15 - 16"/>
          <item value="17" color="#00a123" alpha="255" label="16 - 17"/>
          <item value="18" color="#009b24" alpha="255" label="17 - 18"/>
          <item value="19" color="#009224" alpha="255" label="18 - 19"/>
          <item value="20" color="#008a24" alpha="255" label="19 - 20"/>
          <item value="21" color="#008325" alpha="255" label="20 - 21"/>
          <item value="22" color="#007a24" alpha="255" label="21 - 22"/>
          <item value="23" color="#007122" alpha="255" label="22 - 23"/>
          <item value="24" color="#006c22" alpha="255" label="23 - 24"/>
          <item value="25" color="#005f1f" alpha="255" label="24 - 25"/>
          <item value="26" color="#00561e" alpha="255" label="25 - 26"/>
          <item value="27" color="#004c1b" alpha="255" label="26 - 27"/>
          <item value="28" color="#004419" alpha="255" label="27 - 28"/>
          <item value="29" color="#003112" alpha="255" label="28 - 29"/>
          <item value="29" color="#00250e" alpha="255" label="29 - 29"/>
          <item value="inf" color="#000000" alpha="255" label="> 29"/>
          <rampLegendSettings minimumLabel="" prefix="" maximumLabel="" orientation="2" useContinuousLegend="1" suffix="" direction="0">
            <numericFormat id="basic">
              <Option type="Map">
                <Option value="" name="decimal_separator" type="QChar"/>
                <Option value="6" name="decimals" type="int"/>
                <Option value="0" name="rounding_type" type="int"/>
                <Option value="false" name="show_plus" type="bool"/>
                <Option value="true" name="show_thousand_separator" type="bool"/>
                <Option value="false" name="show_trailing_zeros" type="bool"/>
                <Option value="" name="thousand_separator" type="QChar"/>
              </Option>
            </numericFormat>
          </rampLegendSettings>
        </colorrampshader>
      </rastershader>
    </rasterrenderer>
    <brightnesscontrast contrast="0" gamma="1" brightness="0"/>
    <huesaturation saturation="0" grayscaleMode="0" colorizeOn="0" colorizeBlue="128" colorizeStrength="100" colorizeGreen="128" colorizeRed="255"/>
    <rasterresampler maxOversampling="2"/>
    <resamplingStage>resamplingFilter</resamplingStage>
  </pipe>
  <blendMode>0</blendMode>
</qgis>
