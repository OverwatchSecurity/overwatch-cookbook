# Overwatch Cookbook

Library cookbook that provides [custom resources](https://docs.chef.io/custom_resources.html) for use in recipes.

## Cookbook Dependencies

* [`compat_resource`](https://supermarket.chef.io/cookbooks/compat_resource)

## Resources

### `overwatch_install`

Install Overwatch Agent and register server as Overwatch Device.

#### Example

```ruby
overwatch_install 'my-overwatch-device' do
  token 'my-overwatch-token'
end
```

#### Properties

* `token` (required): Token for your overwatch account.
* `version`: Overwatch version to install.
* `checksum`: SHA256 checksum of package for version.
* `libnetfilter_queue_version`: Version of [`libnetfilter_queue`](http://www.netfilter.org/projects/libnetfilter_queue/) to install. Only applicable for Ubuntu 12.
* `libnetfilter_queue_checksum`: SHA256 checksum of `libnetfilter_queue` source download for version.

#### Actions

* `:create`

## License

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
