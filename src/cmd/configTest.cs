using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Xml;

namespace HGG.AutoCAD
{
    namespace Test
    {
        [TestClass]
        public class ConfigTest
        {
            XmlDocument xmlTest = new XmlDocument();
            Config configurationTest = new Config();

            public ConfigTest()
            {
                string xmlText = "<?xml version=\"1.0\" encoding=\"utf-16\"?>" +
                    "<Configuration><Variables>" +
                    "<Variable Name=\"FONTALT\"><Value>\"LER.SHX\"</Value>" +
                    "<Description>Adding Leroy as alternative font.</Description></Variable>" +
                    "<Variable Name=\"INDEXCTL\"><Value>3</Value>" +
                    "<Description>Layer and spatial indexes are created</Description></Variable>" +
                    "</Variables></Configuration>";
                this.xmlTest.LoadXml(xmlText);
            }

            [TestMethod]
            public void LoadVariables()
            {
                configurationTest.LoadVariables();
                Assert.AreEqual("LER.SHX", configurationTest.AutoCADVariables["FONTALT"]);
            }

            [TestMethod]
            public void LoadVariablesWithBrokenXML()
            {

            }

            [TestMethod]
            public void LoadVariablesWithNoXML()
            {

            }
        }
    }
}