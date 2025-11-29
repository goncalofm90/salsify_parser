# Salsify Parser - README

## How it Works

This script fetches product data from an FTP server, parses XML files, and uploads the processed data to the Salsify API. The workflow is:

1. **FTP Connection**: Connects to the FTP server in passive mode and downloads XML files from the specified directory
2. **XML Parsing**: Uses Ox's SAX parser to efficiently parse large XML files and extract product information
3. **Data Transformation**: Converts XML data into JSON format suitable for the Salsify API
4. **API Upload**: Sends the transformed data to Salsify using Faraday HTTP client
5. **Logging**: Tracks all operations and errors using Ruby's Logger

## Documentation & Resources Consulted

### XML Parsing Research
- [XML with Ruby - Performance Comparison](https://www.ohler.com/dev/xml_with_ruby/xml_with_ruby.html)
- [Reddit: XML Parsing in Ruby Discussion](https://www.reddit.com/r/ruby/comments/23tq1m/xml_parsing_in_ruby/)
- [Nokogiri vs Ox Comparison](https://ruby.libhunt.com/compare-nokogiri-vs-ox)
- [GeeksforGeeks: Ruby JSON Parsing](https://www.geeksforgeeks.org/ruby/how-to-parse-json-in-ruby/)

### FTP & Networking
- [Net::FTP Documentation](https://github.com/ruby/net-ftp)
- [Active vs Passive FTP Modes](https://www.cleo.com/blog/ftp-understanding-active-vs-passive)

### Libraries & Tools
- [Ox SAX Parser](https://github.com/ohler55/ox?tab=readme-ov-file)
- [Faraday HTTP Client](https://lostisland.github.io/faraday/#/)
- [JSON.pretty_generate](https://ruby-doc.org/stdlib-2.4.0/libdoc/json/rdoc/JSON.html#method-i-pretty_generate)
- [Dotenv Configuration](https://github.com/bkeepers/dotenv)
- [Ruby Logger](https://github.com/ruby/logger)
- [Salsify API Documentation](https://www.salsify.com/api-login)
- [AI tools](https://claude.ai/new) AI tools (Claude) were consulted for boilerplating, code structuring, and roadmapping to accelerate development and ensure best practices.


## Third-Party Libraries

### Ox (XML Parser)
**Why chosen over Nokogiri:**
- **Performance**: 40x faster than Nokogiri with SAX parsing (per benchmark in Ox's GitHub).
- **No C compilation bloat**: Nokogiri compiles libxml2 on every gem install unless manually disabled, which bloats applications.
- **Simpler SAX API**: Ox's method for extracting node values is cleaner - Nokogiri's `characters(string)` includes newlines and tab characters that require manual stripping.
- **Pure Ruby C extension**: Ox rolls its own C extension for better memory management vs Nokogiri's libxml dependency. 

**Note**: For HTML parsing requirements, Nokogiri would be the better choice as Ox doesn't support HTML without SAX API. REXML was discarded from the race due to poor performance, encoding issues, and unintuitive APIs.

### Faraday (HTTP Client)
Simple, flexible HTTP client with good middleware support for API interactions. Chosen for its clean interface and reliability both in programming and doc use.

### Dotenv (Environment Configuration)
Industry-standard solution for managing environment variables and credentials securely.

### Logger (Logging)
Ruby's built-in Logger is great and does the required job without external dependencies. I guess for more complex scenarios we could have also used byebug and rubocop for linting.

## Time Spent & Future Improvements

**Time invested**: All around between research and implementation this assignment took around 5 - 6 hours to complete.

**If given unlimited time, prioritized improvements would be:**

1. **Enhanced Error Handling**
   - Implement API retries
   - Implement byebug and rubocop for improved debugging experience

2. **Performance Optimization**
   - Parallel processing of multiple XML files
   - Streaming for large datasets , Faraday is good for this 

   https://lostisland.github.io/faraday/#/adapters/custom/streaming?id=adding-support-for-streaming
   https://piotrmurach.com/articles/streaming-large-zip-files-in-rails/

3. **Monitoring & Observability**
   - Integration with monitoring tools (DataDog, New Relic)
   - Metrics collection (processing time, success rates)
   - Alerts

4. **Testing**
   - Unit Testing (On a larger scale)
   - Integration tests with mock FTP/API servers
   - Performance benchmarks

5. **Configuration**
   - YAML or YML-based configuration file , usually makes credential setting easier and doesn't bloat env
   - Support for multiple environments 
   - Dynamic FTP path configuration (depends on salsify's setup though)

## Code Critique

**Strengths:**
- Modulated classes for FTP, parsing, and API operations
- Error handling/logging
- Well-documented code with inline comments
- Environment-based configuration

**Areas for improvement:**
- Could benefit from dependency injection for better testability
- XML parsing logic could be improved e.g for different product types
- API client with rate limiting
- Missing automated tests

## Note

The code can be a little over-engineered given the context. But this was intentionally done with real-world production scenarios in mind. So we can show:

- **Scalability**: Designed to handle growing data volumes and additional product types (more api methods, multiple xml type parsing,etc.).
- **Maintainability**: Clear structure makes it easy for team members to understand and modify.
- **Production-readiness**: Logging, error handling, and configuration management.

The PR-based development approach used on GitHub was done to mirror daily workflow, demonstrating collaboration and code review practices.

Lastly, if the env credentials are required for testing, please get in touch with me. 