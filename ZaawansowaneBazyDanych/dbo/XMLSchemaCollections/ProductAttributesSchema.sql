CREATE XML SCHEMA COLLECTION [dbo].[ProductAttributesSchema]
    AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="Attributes">
    <xsd:complexType>
      <xsd:complexContent>
        <xsd:restriction base="xsd:anyType">
          <xsd:sequence>
            <xsd:element name="Weight" type="xsd:decimal" minOccurs="0" />
            <xsd:element name="Color" type="xsd:string" minOccurs="0" />
            <xsd:element name="Material" type="xsd:string" minOccurs="0" />
            <xsd:element name="Name" type="xsd:string" minOccurs="0" />
            <xsd:element name="WarrantyMonths" type="xsd:integer" minOccurs="0" />
          </xsd:sequence>
        </xsd:restriction>
      </xsd:complexContent>
    </xsd:complexType>
  </xsd:element>
</xsd:schema>';

