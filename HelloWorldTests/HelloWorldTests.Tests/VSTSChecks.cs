using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace HelloWorldTests.Tests
{
    [TestClass]
    public class VSTSChecks
    {
        [TestMethod]
        public void TestMethod1()
        {
            Assert.IsTrue(false, "Testing is working");
        }

        [TestMethod]
        public void TestMethod2()
        {
            Assert.IsTrue(true, "Testing is not working");
        }
    }
}
