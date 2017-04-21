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
            Config configurationTest = new Config();
            string xmlTestString = "<?xml version=\"1.0\" encoding=\"utf-16\"?>" +
                "<Configuration><Variables>" +
                "<Variable Name=\"Foo\"><Value>\"Foo\"</Value>" +
                "<Description>Foo.d.Bar</Variable>" +
                "<Variable Name=\"Meaning of life\"><Value>42</Value>" +
                "<Description>\"Forty-two,\" said Deep Thought, with infinite majesty and calm.\"</Variable>" +
                "</Variables></Configuration>";
            string xmlBrokenString = "THIS IS NOT AN XML";
            XmlDocument xmlTest = new XmlDocument();

            /// <summary>
            /// Tests Config.ConfigureVariables() to see if variables are added as keys to
            /// dictionary from xml file.
            /// </summary>
            [TestMethod]
            public void ConfigureVariablesWithSucess()
            {
                this.xmlTest.LoadXml(this.xmlTestString);
                Assert.AreEqual(1, this.configurationTest.LoadVariables());
                Assert.AreEqual("Foo", configurationTest.AutoCADVariables["Foo"]);
                Assert.AreEqual("42", configurationTest.AutoCADVariables["Meaning of life"]);
            }

            /// <summary>
            /// Tests Config.ConfigureVariables() to see if variables are were not added as keys
            /// when loading from a failed xml file.
            /// </summary>
            [TestMethod]
            public void ConfigureVariablesWithBadXml()
            {
                this.xmlTest.LoadXml(this.xmlBrokenString);
                Assert.AreEqual(0, this.configurationTest.LoadXml(this.xmlTest));
                Assert.AreEqual(0, configurationTest.AutoCADVariables["Foo"]);
                Assert.AreEqual(0, configurationTest.AutoCADVariables["Meaning of life"]); // There is no hope.
            }

            /// <summary>
            /// Tests Config.ConfigureVariables() to see if variables are were not added as keys
            /// when loading with no xml file.
            /// </summary>
            [TestMethod]
            public void ConfigureVariablesWithNoXML()
            {
                Assert.AreEqual(0, this.configurationTest.LoadXml(this.xmlTest));
                Assert.AreEqual(0, configurationTest.AutoCADVariables["Foo"]);
                Assert.AreEqual(0, configurationTest.AutoCADVariables["Meaning of life"]); // Absolutely none.
            }

            /// <summary>
            /// Tests Config.LoadVariables() to see if good variables were
            /// sucessfuly loaded into Autocad.
            /// </summary>
            [TestMethod]
            public void LoadVariablesWithSucess()
            {
                this.configurationTest.AutoCADVariables.Add("INDEXCTL", "3");
                Assert.AreEqual(1, configurationTest.LoadVariables());
            }

            /// <summary>
            /// Tests Config.LoadVariables() to see if variables were
            /// unsucessfully loaded into Autocad.
            /// </summary>
            [TestMethod]
            public void LoadVariablesWithBadVariable()
            {
                this.configurationTest.AutoCADVariables.Add("FOO", "BARRED");
                Assert.AreEqual(0, configurationTest.LoadVariables());
            }

            /// <summary>
            /// Tests Config.LoadVariables() to see if no variables were
            /// sucessfully loaded into Autocad.
            /// </summary>
            [TestMethod]
            public void LoadVariablesWithNoVariables()
            {
                Assert.AreEqual(0, configurationTest.LoadVariables());
            }
        }
    }
}