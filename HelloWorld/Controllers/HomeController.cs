using HelloWorld.Models;
using HelloWorldClassLibrary;
using Microsoft.AspNetCore.Mvc;

namespace HelloWorld.Controllers
{
    public class HomeController : Controller
    {
        private IConfiguration _configuration;

        public HomeController(IConfiguration config)
        {
            _configuration = config;
        }

        public IActionResult Index()
        {
            var myModel = new MyModel();
            myModel.ID = 12;
            myModel.Message = _configuration.Message;

            return View(myModel);
        }
    }
}